cwalk
=====

To find function definitions for a C project from command line. 

```
cwalk [options]
    -p, --path PATHNAME              The path to look for (optional), defaults to current directory
    -f, --func FUNCNAME              The entry point function (optional), defaults to 'main'
    -h, --help                       Display this screen

Interactive commands: [folder_path] | [source_file_name] | [source_file_name]:[line_number] | line_number | q(to quit)

Example:

$ ./cwalk.rb -p project_path -f foo
...
In project_path:myapp.c:24
void *foo(int a)
{

}

In project_path/subfolder:bar.c:124

int foo()
{
  return 1;
}

cwalk > bar.c

In project_path/subfolder:bar.c:124

int foo()
{
  return 1;
}

cwalk > path/to/another/project/folder

...
```
