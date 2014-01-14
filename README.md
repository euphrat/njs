Not Just Stacks Programming Language
===

Not Just Stacks (NJS) is a programming language that I am developing as a hobby. Some properties of the language are as follows:

* Stack is the only builtin data structure.
* The builtin data types are integers, doubles and strings.
* Variables can only be of type "stack". In other words, there is no way to define an int, double or string variable.
* An NJS program is a collection of "stack processors" which manipulate the stacks that they are pushed to.
* "this" is a special stack which is the operand of the stack processor manipulating it.
* "if", "then" and "else" are special "stack processors" that are used to create "conditional stacks".
* There are no loops. Recursion must be used instead.
* There are no builtin operators other than << (push), >> (pop), *(evaluate), #(size) and &(reference). Libraries should be used for additional functionality (including arithmetic operations).
* "null" is a special stack that can be used to destroy the top element of a stack, e.g. A >> null;

Getting Started with NJS:
============
* I have tested the compiler on Ubuntu 13.10, but I assume it would work on the earlier versions. I'll make a Windows version in the future.
* First, clone the repository: git clone https://github.com/euphrat/njs.git
* In order to build the compiler, you will need g++, make and javac. So, I recommend you install the packages build-essential and default-jdk. 
* Next, you will need some new and updated environment variables. For example, you can update your ~/.bashrc as follows:

```
export NJS_HOME=/home/firat/njs
export PATH=$PATH:$NJS_HOME/bin
export LD_LIBRARY_PATH=$LD_LIBRARY_PATH:$NJS_HOME/njslib:$NJS_HOME/bin
```
* Finally, type make to build the compiler.
* Check out the examples in $NJS_HOME/examples.


Hello World Program:
============
```javascript
 include "njsio":io
 sp main
    %push the string and the stack processor println from the njsio library
    A << "Hello world!" @io.println; 
    %evaluate the stack. since the top element is a stack processor, stack A will be manipulated by it.
    *A; 
 end
```
 

