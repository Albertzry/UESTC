from heapq import heappush, heappop
class Node:
    def __init__(self, matrix=None, x=0, y=0, g=0, h=0, father=None, flag=None):
        if matrix is None:
            matrix = []
            for _ in range(3):
                row = []
                for _ in range(3):
                    row.append(0)
                matrix.append(row)
        self.a = matrix
        self.x = x
        self.y = y
        self.g = g
        self.h = h
        self.f = g + h
        self.father = father
        self.flag = flag

    def __lt__(self, other):
        return self.f < other.f


def input_mat(input_mat):
    print(input_mat)
    mat = []
    zero_x = zero_y = -1
    for i in range(3):
        row = list(map(int, input().split()))
        mat.append(row)
        for j in range(len(row)):
            if row[j] == 0:
                zero_x, zero_y = i, j
    return mat, zero_x, zero_y


def judge(start_mat, goal_mat):
    start1 = []
    for sublist in start_mat:
        for item in sublist:
            if item != 0:
                start1.append(item)

    goal1 = []
    for sublist in goal_mat:
        for item in sublist:
            if item != 0:
                goal1.append(item)

    start2 = 0
    for i in range(len(start1)):
        for j in range(i):
            if start1[j] > start1[i]:
                start2 += 1

    goal2 = 0
    for i in range(len(goal1)):
        for j in range(i):
            if goal1[j] > goal1[i]:
                goal2 += 1

    return (start2 % 2) == (goal2 % 2)


def h(node, goal):
    h = 0
    goal_pos1 = {}
    for i in range(3):
        for j in range(3):
            goal_pos1[goal[i][j]] = (i, j)
    for i in range(3):
        for j in range(3):
            if node.a[i][j] != 0:
                goal_pos2 = goal_pos1[node.a[i][j]]
                h = h + abs(goal_pos2[0] - i) + abs(goal_pos2[1] - j)
    return h


def print_step(node):
    step = 0
    path = ""
    nodes = []
    while node is not None:
        nodes.append(node)
        node = node.father
    for node in reversed(nodes):
        path += f"Step {step}: \n"
        for row in node.a:
            path += ' '.join(map(str, row)) + "\n"
        path += "---------\n\n"
        step += 1
    return step, path


def generate_children(now, goal):
    dir = [(-1, 0), (0, 1), (1, 0), (0, -1)]
    opposite_flags = [2, 3, 0, 1]
    x = now.x
    y = now.y
    chil = []

    for index, (dx, dy) in enumerate(dir):
        nx = x + dx
        ny = y + dy
        if 0 <= nx < 3 and 0 <= ny < 3 and index != now.flag:
            new_mat = [row[:] for row in now.a]
            temp = new_mat[x][y]
            new_mat[x][y] = new_mat[nx][ny]
            new_mat[nx][ny] = temp
            new_node = Node(new_mat, nx, ny, now.g + 1, h(Node(new_mat), goal), now, opposite_flags[index])
            chil.append(new_node)
    return chil


def find_zero(mat):
    for i in range(3):
        for j in range(3):
            if mat[i][j] == 0:
                return i, j


def a_star(start_mat, goal_mat):
    start_node = Node(start_mat, *find_zero(start_mat), 0, h(Node(start_mat), goal_mat))
    open_list = []
    heappush(open_list, start_node)
    visited = set()

    while open_list:
        current_node = heappop(open_list)
        if current_node.a == goal_mat:
            steps, path = print_step(current_node)
            print(path)
            print("\n共计 {} 步完成".format(steps - 1))
            return
        visited.add(tuple(tuple(row) for row in current_node.a))

        for child in generate_children(current_node, goal_mat):
            if tuple(tuple(row) for row in child.a) not in visited:
                heappush(open_list, child)

    print("问题无解。")


def main():
    start_mat, start_x, start_y = input_mat("输入起始八数码图：")
    goal_mat, _, _ = input_mat("输入目标八数码图：")

    if judge(start_mat, goal_mat):
        a_star(start_mat, goal_mat)
    else:
        print("问题无解。")


if __name__ == "__main__":
    main()
