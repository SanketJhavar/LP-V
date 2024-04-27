%%cu
#include <bits/stdc++.h>
using namespace std;
void Intialize(int *a, int n)
{
    for (int i = 0; i < n; i++)
    {
        a[i] = rand() % 10;
    }
}
void print(int *a, int n)
{
    for (int i = 0; i < n; i++)
    {
        cout << a[i] << " ";
    }
    cout << endl;
}
__global__ void add(int *a, int *b, int *c, int n)
{
    int tt = blockIdx.x * blockDim.x + threadIdx.x;
    if (tt < n)
    {
        c[tt] = a[tt] + b[tt];
    }
}
int main()
{
    int n = 5;
    int vectorsize = n;
    size_t vectorByte = vectorsize * sizeof(n);

    int *a, *b, *c;
    a = new int[vectorsize];
    b = new int[vectorsize];
    c = new int[vectorsize];

    Intialize(a, n);
    Intialize(b, n);
    print(a, n);
    print(b, n);

    int *x, *y, *z;
    cudaMalloc(&x, vectorByte);
    cudaMalloc(&y, vectorByte);
    cudaMalloc(&z, vectorByte);

    cudaMemcpy(x, a, vectorByte, cudaMemcpyHostToDevice);
    cudaMemcpy(y, b, vectorByte, cudaMemcpyHostToDevice);

    int thread = 256;
    int block = (n + thread - 1) / 256;
    add<<<block, thread>>>(x, y, z, n);
    cudaMemcpy(c, z, vectorByte, cudaMemcpyDeviceToHost);
    
    print(c,n);
    return 0;
}
