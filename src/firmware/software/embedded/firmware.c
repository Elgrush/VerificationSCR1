//#define N 1024

#define GPIO_ADDR  0x10010000
#define ARRAY_ADDR 0x00010000

int read_int(int addr)
{
    return *(volatile int*)addr;
}

void write_int(int addr,int c)
{
    *(volatile int*)addr = c;
}

int mul_fp(int a,int b)
{
    volatile int answ;
    write_int(0x10011000,a); //write in a
    write_int(0x10011004,b); //write in b
    answ = read_int(0x10011008);//read mul
    return answ;
}

int div_fp(int a,int b)
{
    volatile int answ;
    write_int(0x10011000,a); //write in a
    write_int(0x10011004,b); //write in b
    answ = read_int(0x1001100C);//read div
    return answ;
}

int exp_fp(int x) //taylor series
{
    int answ = 0; //1.0 for FP_32_16
    int term = 0x10000;
    int divisor = 0x10000;

    for(int i=1;i<8;i++)
    {   
        term = mul_fp(term,x);
        answ += div_fp(term,divisor);
        divisor = mul_fp(divisor,(i+1)*(int)0x10000);
    }

    return answ+0x10000;
}

int sqroot_fp(int square)
{
    int root=div_fp(square,0x30000);
    int i;
    if (square <= 0) return 0;
    for (i=0; i<20; i++)
    {
        int a = div_fp(square,root);
        int a1 = root + a;
        root = div_fp(a1, 0x20000);
    }

    return root;
}

int Bartlett_fp(int n, int offset,int W)
{
    volatile int window = 0;

    volatile int arg = div_fp(W,0x20000);    //W/2
    //write_int(0x10010000,arg);
    arg = n - offset - arg;         //n - offset - W/2
    //write_int(0x10010000,arg);
    if(arg < 0) arg = 0 - arg;       //abs == abs(n - offset - W/2)
    arg = mul_fp(arg,0x20000);      //2*abs
    //write_int(0x10010000,arg);
    arg = W - arg;                  // W-2abs
    if(arg < 0) return 0; 
    //write_int(0x10010000,arg);
    arg = div_fp(arg,W);            //(W-2abs)/W
    //write_int(0x10010000,arg);
              //if <0 return 0
    return arg;
}

//**************************************************************//

void swap(int* a, int* b) {
    int temp = *a;
    *a = *b;
    *b = temp;
}

int partition(int arr[], int low, int high) {

    // Initialize pivot to be the first element
    int p = arr[low];
    int i = low;
    int j = high;

    while (i < j) {

        // Find the first element greater than
        // the pivot (from starting)
        while (arr[i] <= p && i <= high - 1) {
            i++;
        }

        // Find the first element smaller than
        // the pivot (from last)
        while (arr[j] > p && j >= low + 1) {
            j--;
        }
        if (i < j) {
            swap(&arr[i], &arr[j]);
        }
    }
    swap(&arr[low], &arr[j]);
    return j;
}

void quickSort(int arr[], int low, int high) {
    if (low < high) {

        // call partition function to find Partition Index
        int pi = partition(arr, low, high);

        // Recursively call quickSort() for left and right
        // half based on Partition Index
        quickSort(arr, low, pi - 1);
        quickSort(arr, pi + 1, high);
    }
}

void main()
{

    int* arr = (int*)(ARRAY_ADDR)+1;
    int size_of_array = *(int*)ARRAY_ADDR;
    *(int*)ARRAY_ADDR = 0x1488;

    quickSort(arr, 0, size_of_array - 1);
}
