import pandas as pd
from math import log2
from collections import Counter
from graphviz import Digraph

class Node:
    def __init__(self, feature=None, threshold=None, label=None):
        self.feature = feature
        self.threshold = threshold
        self.label = label
        self.children = {}

def load_data(train, test):
    train_data = pd.read_csv(train, header=None, sep='\t')
    test_data = pd.read_csv(test, header=None, sep='\t')
    return train_data, test_data

def entropy(inputs):
    total = len(inputs)
    cou = Counter(inputs)
    enva = 0.0
    for label in cou:
        pb = cou[label] / total
        enva -= pb * log2(pb)
    return enva

def info_gain(data, feature_idx, label_idx):
    sorted_data = data.sort_values(by=feature_idx)
    values = sorted_data[feature_idx].values
    labels = sorted_data[label_idx].values
    total_entropy = entropy(labels)
    best_gain = 0
    best_threshold = None
    
    for i in range(1, len(values)):
        if values[i] == values[i-1]:
            continue
        threshold = (values[i] + values[i-1]) / 2
        left_labels = labels[:i]
        right_labels = labels[i:]
        left_entropy = entropy(left_labels)
        right_entropy = entropy(right_labels)
        weighted_entropy = (len(left_labels) / len(labels)) * left_entropy + (len(right_labels) / len(labels)) * right_entropy
        gain = total_entropy - weighted_entropy
        if gain > best_gain:
            best_gain = gain
            best_threshold = threshold

    return best_gain, best_threshold

def constree(data, label_idx, feature_indices):
    labels = data.iloc[:, label_idx]
    if len(set(labels)) == 1:
        return Node(label=labels.iloc[0])
    
    if not feature_indices:
        return Node(label=labels.mode()[0])
    
    best_feature_idx = feature_indices[0]
    best_gain, best_threshold = info_gain(data, best_feature_idx, label_idx)
    for feature_idx in feature_indices[1:]:
        gain, threshold = info_gain(data, feature_idx, label_idx)
        if gain > best_gain:
            best_gain = gain
            best_feature_idx = feature_idx
            best_threshold = threshold
    
    if best_gain == 0:
        return Node(label=labels.mode()[0])
    
    tree = Node(feature=best_feature_idx, threshold=best_threshold)
    left_data = data[data[best_feature_idx] <= best_threshold]
    right_data = data[data[best_feature_idx] > best_threshold]
    tree.children['<='] = constree(left_data, label_idx, feature_indices)
    tree.children['>'] = constree(right_data, label_idx, feature_indices)
    
    return tree

def classify(tree, instance):
    if tree.label is not None:
        return tree.label
    
    feava = instance[tree.feature]
    if feava <= tree.threshold:
        return classify(tree.children['<='], instance)
    else:
        return classify(tree.children['>'], instance)

def classify_data(tree, data):
    pre = []
    for i in range(len(data)):
        pred = classify(tree, data.iloc[i])
        pre.append(pred)
    return pre

def accuracy(pred, labels):
    corr = 0
    for i in range(len(pred)):
        if pred[i] == labels.iloc[i]:
            corr += 1
    acc = corr / len(pred)
    return acc

def visual(tree, dot=None, parent=None, edge_label=None):
    if dot is None:
        dot = Digraph()
        dot.attr('graph', ranksep='0.5', nodesep='5') 
        dot.attr('node', shape='ellipse', style='filled', fillcolor='lightblue', fontname="Helvetica", fontsize="20")
        dot.attr('edge', fontname="Helvetica", fontsize="30")
    
    if tree.feature is not None:
        dot.node(name=str(id(tree)), label=f"Feature {tree.feature}\n {tree.threshold}")
    else:
        dot.node(name=str(id(tree)), label=f"Label {tree.label}", shape='box', fillcolor='lightgreen')
    
    if parent is not None:
        dot.edge(str(parent), str(id(tree)), label=str(edge_label))
    
    for value, child in tree.children.items():
        visual(child, dot, id(tree), value)
    
    return dot

if __name__ == "__main__":
    train_data, test_data = load_data('traindata.txt', 'testdata.txt')

    label_idx = 4  
    feature_indices = list(range(4))  
    decision_tree = constree(train_data, label_idx, feature_indices)

    test_labels = test_data.iloc[:, label_idx]
    test_predictions = classify_data(decision_tree, test_data)

    print("分类准确率:", accuracy(test_predictions, test_labels))

    dot = visual(decision_tree)
    dot.render("decision_tree_visualization", format="png")
