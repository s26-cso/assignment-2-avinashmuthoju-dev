#include<stdio.h>
#include<stdlib.h>
#include<string.h>
#include<dlfcn.h>

typedef int (*op_func)(int, int);

int main(){
    char operation[7];  
    int a,b;
    
    while(scanf("%5s %d %d",operation,&a,&b)==3){
        char library_name[20];

        snprintf(library_name,sizeof(library_name),"./lib%s.so",operation);

        void *lib_handle=dlopen(library_name,RTLD_LAZY);

        op_func operation_ptr=(op_func)dlsym(lib_handle,operation);

        int ans=operation_ptr(a,b);
        printf("%d\n",ans);
        dlclose(lib_handle);
    }
    return 0;
}