import os
import shutil
import ttkbootstrap as ttk
from ttkbootstrap.constants import *
from PIL import Image, ImageTk
import tensorflow as tf
from sklearn.cluster import KMeans
from sklearn.decomposition import PCA
from tkinter import filedialog, messagebox

class ImageClusteringApp:
    def __init__(self, root):
        self.root = root
        self.root.title("图片聚类工具")
        self.root.geometry("1920x1080")

        self.image_folder = None
        self.images = []
        self.features = []
        self.cluster_labels = []
        self.n_clusters = ttk.IntVar(value=2)
        self.model_name = ttk.StringVar(value="EfficientNetB0")  # 默认模型
        self.input_size = (224, 224)
        self.model = self.load_model(self.model_name.get())

        # 创建GUI组件
        self.create_widgets()

    def create_widgets(self):
        """
        创建应用程序的GUI组件，包括按钮、进度条和滚动画布。
        """
        # 模型选择下拉菜单
        model_label = ttk.Label(self.root, text="选择模型:")
        model_label.pack(pady=5)

        # 更新模型选项为带有描述的格式
        model_options = [
            "EfficientNetV2S(质量)",
            "EfficientNetB0(推荐)",
            "MobileNetV3Small(效率)"
        ]
        self.model_menu = ttk.Combobox(
            self.root, textvariable=self.model_name, values=model_options, state="readonly"
        )
        self.model_menu.current(1)
        self.model_menu.bind("<<ComboboxSelected>>", lambda e: self.switch_model(self.model_name.get()))
        self.model_menu.pack(pady=5)

        self.select_folder_button = ttk.Button(
            self.root, text="选择图片文件夹", command=self.select_folder, bootstyle=PRIMARY
        )
        self.select_folder_button.pack(pady=10)

        # 显示加载进度的文本
        self.progress_text = ttk.Label(self.root, text="加载进度: 0/0")
        self.progress_text.pack(pady=5)

        # 创建进度条
        self.progress_bar = ttk.Progressbar(self.root, orient=HORIZONTAL, length=600, mode="determinate")
        self.progress_bar.pack(pady=10)

        # 聚类数量输入框
        self.cluster_label = ttk.Label(self.root, text="聚类数量:")
        self.cluster_label.pack(pady=5)
        self.cluster_entry = ttk.Entry(self.root, textvariable=self.n_clusters)
        self.cluster_entry.pack(pady=5)

        # “开始聚类”按钮
        self.cluster_button = ttk.Button(
            self.root, text="开始聚类", command=self.start_clustering, bootstyle=DANGER
        )
        self.cluster_button.pack(pady=10)

        self.create_scrollable_canvas()

        self.save_button = ttk.Button(
            self.root, text="保存聚类结果", command=self.save_results, bootstyle=DARK
        )
        self.save_button.pack(pady=10)

    def create_scrollable_canvas(self):
        container = ttk.Frame(self.root)
        container.pack(fill=BOTH, expand=True)

        self.scroll_canvas = ttk.Canvas(container, width=self.root.winfo_width() - 20, height=400)
        self.scroll_canvas.pack(side=LEFT, fill=BOTH, expand=True)

        scrollbar = ttk.Scrollbar(container, orient=VERTICAL, command=self.scroll_canvas.yview)
        scrollbar.pack(side=RIGHT, fill=Y)

        self.scroll_canvas.configure(yscrollcommand=scrollbar.set)

        self.scrollable_frame = ttk.Frame(self.scroll_canvas)
        self.scrollable_frame.bind(
            "<Configure>",
            lambda e: self.scroll_canvas.configure(scrollregion=self.scroll_canvas.bbox("all"))
        )

        self.scroll_canvas.create_window((0, 0), window=self.scrollable_frame, anchor="nw")

        # 绑定鼠标滚轮事件
        self.scroll_canvas.bind_all("<MouseWheel>", self._on_mouse_wheel)

    def _on_mouse_wheel(self, event):
        self.scroll_canvas.yview_scroll(-1 * (event.delta // 120), "units")

    def load_model(self, model_name):
        """
        根据模型名称加载对应的预训练模型，并设置输入大小。
        """
        if model_name == "EfficientNetV2S":
            self.input_size = (300, 300)
            return tf.keras.applications.EfficientNetV2S(
                weights="imagenet", include_top=False, pooling="avg", input_shape=(300, 300, 3)
            )
        elif model_name == "EfficientNetB0":
            self.input_size = (224, 224)
            return tf.keras.applications.EfficientNetB0(
                weights="imagenet", include_top=False, pooling="avg", input_shape=(224, 224, 3)
            )
        elif model_name == "MobileNetV3Small":
            self.input_size = (224, 224)
            return tf.keras.applications.MobileNetV3Small(
                weights="imagenet", include_top=False, pooling="avg", input_shape=(224, 224, 3)
            )
        else:
            raise ValueError("不支持的模型名称")

    def switch_model(self, selected_model):
        """
        切换模型时重新加载对应的预训练模型，并更新输入大小。
        """
        actual_model_name = selected_model.split("(")[0]
        self.model = self.load_model(actual_model_name)
        messagebox.showinfo("信息", f"切换到模型: {selected_model}，请选择图片文件夹")

    def select_folder(self):
        self.image_folder = filedialog.askdirectory()
        if self.image_folder:
            self.images = []
            self.features = []

            # 获取文件列表
            image_files = [f for f in os.listdir(self.image_folder) if f.endswith((".jpg", ".png", ".jpeg"))]
            total_files = len(image_files)

            if total_files == 0:
                messagebox.showinfo("信息", "文件夹中没有图片")
                return

            # 配置进度条
            self.progress_bar["maximum"] = total_files
            self.progress_bar["value"] = 0
            self.progress_text.config(text=f"加载进度: 0/{total_files}")

            for i, filename in enumerate(image_files):
                img_path = os.path.join(self.image_folder, filename)
                img = tf.keras.preprocessing.image.load_img(img_path, target_size=self.input_size)  # 使用动态输入大小
                img_array = tf.keras.preprocessing.image.img_to_array(img)
                img_array = tf.keras.applications.efficientnet.preprocess_input(img_array)
                img_array = tf.expand_dims(img_array, axis=0)

                feature = self.model.predict(img_array)
                self.features.append(feature.flatten())
                self.images.append(img_path)

                # 更新进度条和文本
                self.progress_bar["value"] = i + 1
                self.progress_text.config(text=f"加载进度: {i + 1}/{total_files}")
                self.root.update()  # 刷新 UI

            messagebox.showinfo("信息", f"已加载 {len(self.images)} 张图片，请输入聚类数量")

    def start_clustering(self):
        if not self.images:
            messagebox.showerror("错误", "请先选择图片文件夹")
            return

        n_clusters = self.n_clusters.get()
        if n_clusters <= 0:
            messagebox.showerror("错误", "聚类数量必须大于0")
            return

        n_samples = len(self.features)
        n_features = len(self.features[0]) if self.features else 0
        n_components = min(50, n_samples, n_features)

        if n_components <= 0:
            messagebox.showerror("错误", "数据不足以进行降维")
            return

        pca = PCA(n_components=n_components, random_state=42)
        reduced_features = pca.fit_transform(self.features)

        kmeans = KMeans(
            n_clusters=n_clusters, init='k-means++', n_init=20, max_iter=5000,
            tol=1e-5, random_state=42, algorithm='lloyd'
        )
        self.cluster_labels = kmeans.fit_predict(reduced_features)

        self.display_clusters()

    def display_clusters(self):
        for widget in self.scrollable_frame.winfo_children():
            widget.destroy()

        cluster_images = [[] for _ in range(self.n_clusters.get())]

        for img_path, label in zip(self.images, self.cluster_labels):
            cluster_images[label].append(img_path)

        img_width, img_height = 100, 100
        padding_x, padding_y = 10, 10

        # 动态计算最大列数
        canvas_width = self.scroll_canvas.winfo_width()
        max_columns = max(1, ((canvas_width - padding_x*2) // (img_width + padding_x))-2)

        y_offset = 0
        total_images = len(self.images)  # 总图片数量
        for i, cluster in enumerate(cluster_images):
            cluster_count = len(cluster)  # 当前类别的图片数量
            label = ttk.Label(
                self.scrollable_frame,
                text=f"聚类 {i+1} ({cluster_count}/{total_images})",
                anchor="w"
            )
            label.grid(row=y_offset, column=0, sticky="w", pady=(0, 10), columnspan=max_columns)
            y_offset += 1

            x_offset = 0
            for j, img_path in enumerate(cluster):
                img = Image.open(img_path)
                img = img.resize((img_width, img_height), Image.Resampling.LANCZOS)
                photo = ImageTk.PhotoImage(img)

                img_label = ttk.Label(self.scrollable_frame, image=photo)
                img_label.image = photo
                img_label.grid(row=y_offset, column=x_offset, padx=padding_x, pady=padding_y)

                x_offset += 1
                if x_offset >= max_columns:
                    x_offset = 0
                    y_offset += 1

            y_offset += 1

    def save_results(self):
        if len(self.cluster_labels) == 0:
            messagebox.showerror("错误", "请先执行聚类")
            return

        save_folder = filedialog.askdirectory()
        if not save_folder:
            messagebox.showerror("错误", "未选择保存文件夹")
            return

        cluster_result_folder = os.path.join(save_folder, "cluster_result")
        if not os.path.exists(cluster_result_folder):
            os.makedirs(cluster_result_folder)

        for i in range(self.n_clusters.get()):
            cluster_folder = os.path.join(cluster_result_folder, f"cluster_{i+1}")
            if not os.path.exists(cluster_folder):
                os.makedirs(cluster_folder)

            for img_path, label in zip(self.images, self.cluster_labels):
                if label == i:
                    shutil.copy(img_path, cluster_folder)

        messagebox.showinfo("信息", "聚类结果已保存")

if __name__ == "__main__":
    root = ttk.Window(themename="morph")
    app = ImageClusteringApp(root)
    root.mainloop()