# **Coding Standards**

Creating cleaner code means writing code that is readable, efficient, and effectively detects bugs and errors. Coding standards are a set of guidelines that help developers express their decisions clearly, facilitating collaboration with other developers and stakeholders who may review the code.

Naming Conventions

We will use camelCase for naming functions, classes, and variables. This enhances readability and understanding of each entity's functionality. Names should be concise yet descriptive, avoiding overly short or cryptic names like "X." The names should clearly describe the purpose of variables, functions, and classes.

### Formatting

For frontend development, we will use **Flutter linter rules** configured both locally and in our CI/CD pipeline. This automation ensures consistent linting with rules such as:

* `prefer_const_constructors_in_immutables`: Optimizes performance by using const constructors in immutable classes.  
* `use_key_in_widget_constructors`: Improves widget state preservation and performance by using the key parameter in widget constructors.  
* `non_constant_identifier_names`: Enforces camelCase naming convention for non-constant identifiers.  
* `unused_import`: Flags unused imports to keep our codebase clean.

Indentation will use 2 spaces for tabs, ensuring consistent formatting with a Dart built-in formatter.

For backend development, we will use **Ktlint** with the following rules:

* `indent_style` and `tab_width`: Indentation will be set to 3 spaces.  
* `UnusedImports`: Reports and removes unused imports in Kotlin code.

### Commenting

Comments should briefly describe code functionality to aid readability. Avoid overly descriptive comments and place them above the relevant code section.

### File Structure and Organization

Backend:

* Controllers folder  
* Service folder  
* **File naming in UpperCamelCase format.**

Frontend:

* Pages, Screens, Services, Widgets folders  
* **Main file naming in snake\_case format.**

### Git Standards

Git Flow:

* Main: Production-ready branch.  
* Develop: Ongoing development branch.  
* Feature: Temporary branches for new features.  
* Release: Preparing new release versions.

Branch Naming Convention:

* Features: **feat**/\<nameOfTheFeature\>  
* Bug fixes: **fix**/\<nameOfTheBugFixes\>  
* Documentation: **docs**/\<nameOfDocumentationName\>

Commit Message Standards:

* Minimum of 10 words per commit.  
* Use of  "Bug" keyword for minor fixes with the feature/component name that was fixed.  
* Provide a clear explanation of changes, potentially in bullet points.

### Code Reviews

* At least one reviewer must approve pull requests.  
* All CI/CD checks must pass before merging.  
* Pull requests should include tags, mention addressed milestones, a descriptive title, and an explanatory body.

Missing components 

- [ ] Architectural style organisation-how we should organise our files based on our architectural structure  
- [ ] 