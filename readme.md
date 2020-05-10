In our work, we often have to deal with various stuff related to the project, but at the same time not under the control of versions (such as various passwords, access tokens, links to the necessary resources, terminal snippets and so on).

Usually people store all this in their home directory, in the Documents folder, in some google documents, and often in all these places combined. As a result, finding the right one thing quickly is very difficult.

In addition, each task that is being solved is usually surrounded by artifacts, such as SQL queries, API requests, used in development, fragments of messages in different messengers that can be difficult to find - all this relates to a specific task, and at the same time, may be useful in the future when solving similar tasks, and, of course, it should not fall into the project repository.

GIT provides the ability to store all this in one folder in the project, at the same time excluded from the repository, and not registered in the `.gitignore` file. To do this, it is enough to register this folder in the `.git/info/exclude` file (in my case, I just added the `1_stuff` line there - I chose the name of the folder for sorting reasons, so that it is always the first in the project folder).

The `common` folder contains commonly used stuff.

For individual tasks, I made a standard template, presented as the `template` folder. It contains the following files:
* `1_stuff.txt` - common information about task, related files, console commands etc;
* `3_sql.sql` - SQL queries, used in development. My IDE (like all other jetbrains products) allows you to perform database queries directly from any file, and in `*.sql` files also highlights syntax automatically;
* `5_json.json` - used for quickly format JSON data;
* `7_rest.http` - used for API requests. IDEs by jetbrains allow to write REST requests, with headers, parameters, etc. In most cases, this is more convenient than postman, because you do not need to switch to another program during the development process. API development can take place completely in IDE, without switching to postman or browser;

When starting a new task, I simply copy this folder to a new one, with the task number and a brief description, which in the future will become a description of the commit. After the task completed, it is transferred to the archive folder.

I wrote some simple bash scripts to automate this process:

* `./new` - asks for some task parameters (i.e. project, task ID, description, etc.), and does two things: creates new folder for task artifacts and generates message for future commit (this message inputs into `1_stuff.txt` file). Folder and commit templates config described below; Also accepts input parameters that are applied sequentially to the template fields.
```shell script
1_stuff/new [!] SB 1
```
* `./move` - this script intended for transfer task folder between different places - `root` (current tasks), `test`, `pause`, and `archive`. `test` and `pause` folders located in `archive` directory, but `archive` place means special directories inside `archive` folder, named with current year and month.
```shell script
1_stuff/move -a SB-1
```
* `./find` - it's just a wrapper over the `find` and `grep` commands. It searches for the passed string in the task names and in the contents of the files, and displays only the folder names. Note that only searches in the `archive` folder.
```shell script
1_stuff/find "some string"
```

Configs (`cfg` folder):
* `cfg` contains `folderTemplate` and `commitTemplate` parameters. These are simple templates for task folder and commit descriptions respectively.
* `task_cfg` contains task fields descriptions. They are described in the following format:
```
field_description|template_code|default_value
```
where:
 
* `field_description` represents the prompt displayed when creating a task;
* `template_code` used in folder and commit templates;
* `default_value` - no comments.
