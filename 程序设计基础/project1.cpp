#include <stdio.h>
struct ipsubnet 
{
    int subnet[4];
    int mask[4];
    int counter;
};//存储子网
struct ip 
{
    int  ip[4];
};//存储IP
struct com
{
    int tem[4];
};//存储临时比对
int main() 
{
    struct ipsubnet subnets[64];
    int n = 0;
    struct ip ips[64];
    int m = 0;
    struct com temp[64];
    //
    FILE* fp = fopen("D:\subnet.txt", "r");
    if (fp == NULL) 
    {
        printf("open D:\subnet.txt" "error!");
        return -1;
    }
    while (!feof(fp)) 
    {
        fscanf(fp, "%d.%d.%d.%d", 
            &subnets[n].subnet[0], &subnets[n].subnet[1],
            &subnets[n].subnet[2], &subnets[n].subnet[3]);
        fscanf(fp, "%d.%d.%d.%d", 
            &subnets[n].mask[0], &subnets[n].mask[1],
            &subnets[n].mask[2], &subnets[n].mask[3]);
        subnets[n].counter = 0;
        n++;
    }
    fclose(fp);//读入存储子网文件
    FILE* fq = fopen("D:\IP.txt", "r");
    if (fq == NULL)
    {
        printf("open D:\IP.txt" "error!");
        return -1;
    }
    while (!feof(fq))
    {
        fscanf(fq, "%d.%d.%d.%d", 
            &ips[m].ip[0], &ips[m].ip[1],
            &ips[m].ip[2], &ips[m].ip[3]);
        m++;
    }
    fclose(fq);//读入存储IP
    for (int i = 0; i < m; i++)
    {
        for (int o = 0; o < n; o++)
        {
            temp[i].tem[0] = (ips[i].ip[0]) & (subnets[o].mask[0]);
            temp[i].tem[1] = (ips[i].ip[1]) & (subnets[o].mask[1]);
            temp[i].tem[2] = (ips[i].ip[2]) & (subnets[o].mask[2]);
            temp[i].tem[3] = (ips[i].ip[3]) & (subnets[o].mask[3]);
            if ((temp[i].tem[0] == subnets[o].subnet[0]) && 
                (temp[i].tem[1] == subnets[o].subnet[1]) && 
                (temp[i].tem[2] == subnets[o].subnet[2]) && 
                (temp[i].tem[3] == subnets[o].subnet[3]))
            {
                subnets[o].counter ++;
            }
        }
     }//统计算法
    FILE* fr = fopen("D:\\rusult.txt", "w + ");
    if (fr == NULL) 
    {
        printf("open file error!");
        return -1;
    }
    for (int u = 0; u < n;u++)
    {
        fprintf(fr, "%d.%d.%d.%d\t%d.%d.%d.%d\t%d\n", 
            subnets[u].subnet[0], subnets[u].subnet[1],
            subnets[u].subnet[2], subnets[u].subnet[3],
            subnets[u].mask[0], subnets[u].mask[1],
            subnets[u].mask[2], subnets[u].mask[3], 
            subnets[u].counter);
    }
    fclose(fr);//输出结果
    return 0;
}
