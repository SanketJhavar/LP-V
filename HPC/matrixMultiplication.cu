%%cu
#include <bits/stdc++.h>
using namespace std;
__global__ void mulitply(int *a, int *b, int *c, int n)
{
    int row = blockIdx.y * blockDim.y + threadIdx.y;
    int col = blockIdx.x * blockDim.x + threadIdx.x;

    if (row < n and col < n)
    {
        int sum = 0;
        for (int i = 0; i < n; i++)
        {
            sum += a[row * n + i] * b[i * n + col];
        }
        c[row * n + col] = sum;
    }
}
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
        for (int j = 0; j < n; j++)
        {
            cout << a[i * n + j] << " ";
        }
        cout << endl;
    }
}
int main()
{
    int n = 2;
    int matrixsize = n * n;
    size_t metrixByte = matrixsize * sizeof(int);

    int *a, *b, *c;
    a = new int[matrixsize];
    b = new int[matrixsize];
    c = new int[matrixsize];

    Intialize(a, n);
    Intialize(b, n);

    print(a, n);
    print(b, n);
    int *x, *y, *z;

    cudaMalloc(&x, metrixByte);
    cudaMalloc(&y, metrixByte);
    cudaMalloc(&z, metrixByte);

    cudaMemcpy(x,a,metrixByte,cudaMemcpyHostToDevice);
    cudaMemcpy(y,b,metrixByte,cudaMemcpyHostToDevice);

    int thread = 2;
    int block = n/thread;

    mulitply<<<block,thread>>>(x,y,z,n);
    cudaMemcpy(c,z,metrixByte,cudaMemcpyDeviceToHost);
    print(c,n);
    return 0;
}
