#include <string>
#include <vector>
#include <fstream>
#include <iostream>
#include <algorithm>
#include <sstream>
using namespace std;
class Contact 
{
public:
    void SetName(string newName)
    {
        this->m_Name = newName;
    };
    string GetName()
    {
        return this->m_Name;
    }
    void SetPhone(string newPhone)
    {
        this->m_Phone = newPhone;
    };
    string GetPhone()
    {
        return this->m_Phone;
    }
    void AddPhone(string newPhone)
    {
        this->m_Phone = newPhone;
    };
    Contact(string name, string phone)
    {
        this->m_Name = name;
        this->m_Phone = phone;
    }
public:
    string m_Name;
    string m_Phone;
};
bool CheckPoint = false;
vector<Contact> Person;
int num = sizeof(Contact);
int main() 
{
    bool ifcontinue=true;
    string name;
    string phone;
    Contact c1(name,phone);
    ofstream out;
    vector<Contact> Person;
    out.open("pohonebook.txt");    
  fstream file;
    file.open("d:\\phonebook.txt",ios::in);
    if(!file)
    {
        cout << "Open file error!" << endl;
    }
    else
    {
        while(!file.eof())
        {
            file>>name>>phone;
            Contact contacts1(name,phone);
            Person.push_back(contacts1);
        }
    }
    while (ifcontinue) 
    {
        char op;
        cout<<"Please select operator: 1::add 2::del 3::query 4::modify 5::list 0::quit"<<endl;
        cin>>op;
        switch(op)
        {
            case '1'://add
                cout << "请输入姓名： " << endl;
                cin >> name;
                cout << "请输入电话: " << endl;
                cin >> phone;
                c1.SetName(name);
                c1.SetPhone(phone);
                Person.push_back(c1);
                cout << "添加成功!!!" << endl;
                break;
            case '2'://del
                CheckPoint = false;
                cout << "请输入要删除的联系人的姓名: " << endl;
                cin >> name;
                for (int i = 0; i < Person.size(); i++)
                {
                    if (Person[i].m_Name == name)
                    {
                        Person.erase(Person.begin() + i);//删除联系人
                        cout << "删除成功！！！" << endl;
                        CheckPoint = true;
                    }
                }
                if(CheckPoint == false)
                        cout << "查无此人!" << endl;
                break;
            case '3'://query
                CheckPoint = false;
                cout << "请输入要查询的联系人姓名：" << endl;
                cin >> name;
                for (int i = 0; i < Person.size(); i++)
                {
                    if (Person[i].m_Name == name)
                    {
                        cout << "您查找的联系人的电话号码是: " << Person[i].m_Phone << endl;
                        CheckPoint = true; 
                        break;
                    }
                }
                if (CheckPoint == false)
                        cout << "查无此人!" << endl;
                break;
            case '4'://modify
                CheckPoint = false;
                cout << "请输入需要修改的对象的姓名 : " << endl;
                cin >> name;
                for (int i = 0; i < Person.size(); i++)//遍历寻找姓名
                {
                    if (Person[i].m_Name == name)
                    {
                        cout << "请输入修改目标的新手机号: " << endl;
                        cin >> phone;
                        Person[i].SetPhone(phone);//修改手机号
                        cout << "修改成功！！！" << endl;
                        CheckPoint=true;
                        break;
                    }
                }
                if (CheckPoint == false)
                    cout << "查无此人!" << endl;
                break;
            case '5'://list
                if (Person.size() == 0)
                    cout << "您的电话簿中联系人个数为0!!!" << endl;
                for (int i = 0; i < Person.size(); i++)
                {
                    cout << Person[i].GetName() + "\t";
                    cout << Person[i].GetPhone() + "\n";
                }
                break;
            case '0':
                cout << "欢迎下次使用!!!" << endl;
                ifcontinue = false;
                break;
            default:
                cout<<"invalid operator,please select operatror again"<<endl;
        }
    }
    fstream afile;
    string word;
    afile.open("d:\\phonebook.txt", ios::out);
    if (!afile) 
    {
        cout << "Open file failed" << endl;
    }
    else
    {
        for (int i = 0; i < Person.size(); i++)
        {
            if (i < Person.size()-1)
            {
                afile << Person[i].GetName() + "\t" << Person[i].GetPhone() + "\n";
            }
            else
            { 
                afile << Person[i].GetName() + "\t" << Person[i].GetPhone();
            }
        }
    }
    afile.close();
}