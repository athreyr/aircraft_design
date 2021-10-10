(This file is best viewed at [its Github page](https://github.com/athreyr/aircraft_design).)

INSTRUCTIONS FOR CONTRIBUTING TO THIS PROJECT
---------------------------------------------

Let's try to keep it simple (at least for now). You can contribute by raising:

- an [Issue](https://docs.github.com/en/issues/tracking-your-work-with-issues/creating-an-issue), if you find that the code isn't behaving as it should, and you just want it fixed, but don't necessarily care about the how or why of the problem. If at a later point, you feel like you have solved it and everyone could benefit from it, you can [link a Pull Request](https://docs.github.com/en/issues/tracking-your-work-with-issues/linking-a-pull-request-to-an-issue) with it.

- a [Pull Request](https://docs.github.com/en/github/collaborating-with-pull-requests/proposing-changes-to-your-work-with-pull-requests/creating-a-pull-request), if you think that something in the code can be modified to make it better (fix a bug, disambiguate some documentation, add new features, etc.), and you are **willing to**<sup id="a1">[1](#f1)</sup> make that happen.

Either way, follow these steps when you're writing code to be included in this project:

1. MATLAB code guidelines can be found [here](https://www.mathworks.com/matlabcentral/fileexchange/2529-matlab-programming-style-guidelines), [here](https://www.mathworks.com/matlabcentral/fileexchange/46056-matlab-style-guidelines-2-0), and [here](https://www.mathworks.com/matlabcentral/fileexchange/36540-updates-to-the-elements-of-matlab-style). It's important that new code follows the same style conventions as the existing ones. In addition to the guidelines mentioned above, the project follows other conventions as described in later points.

2. An expression involving a dot (".") could mean different things depending on relative cases as follows:

    | Expression	| Dot prefix could be 			| Dot suffix could be											            |
    | ---------- 	| ------------------- 			| ------------------- 											            |
    | `Foo.bar`		| Struct, Table, Object, Class	| field, variable, property/ method (could be static)			            |
    | `Foo.Bar`		| Struct, Table, Object, Class	| Struct, Table, Object, Class	(could be static) 				            |
    | `Foo.BAR`		| Struct, Table, Object, Class	| field, variable, property (could be static)<sup id="a2">[2](#f2)</sup>    |
    | `foo.bar`		| package						| package, function			 									            |
    | `foo.Bar`		| package						| Class															            |

3. Use `list` as variable suffix to represent pluralization for heterogenous data structures like `cell` arrays, and `array` as that for homogenous data structures like numeric and/or object arrays. Try to use `s` to denote plurals only if you are not going to index into the array, and instead treat it as a single entity.<sup id="a3">[3](#f3)</sup>

4. As far as possible, write backward compatible code (e.g. `regexp` instead of `string` functions), except in cases where there are significant performance/ readability advantages using new functions (e.g. `strjoin(x)` instead of `ans = strcat(vertcat(x{:}), ' '); [ans{:}]`). In those situations, define a new wrapper function that calls either of the two functions depending on `verLessThan`.

5. Most functions can operate on an entire cell array, making `cellfun` a redundant (and perhaps slower) choice, except for specific cases, e.g. `cellfun('isempty', varargin)` (note the [function name as a char](https://www.mathworks.com/help/matlab/ref/cellfun.html#d123e159687)).

6. Use [comma-separated lists](https://www.mathworks.com/help/matlab/matlab_prog/comma-separated-lists.html) to increase code readability and performance where there are `cell`, `struct`, or object arrays.

7. When naming variables, try to avoid underscores as much as possible, except for constants, e.g. `SPECIFIC_GAS_CONSTANT`. Write variable and function names in `lowercase` (or `camelCase` if required), and leave underscores for filenames.

8. Use [containers.Map](https://www.mathworks.com/help/matlab/map-containers.html) instead of `struct` to group named information having values of same datatype together. (This is still only being implemented, so that's a good first TODO item)

You can find the list of pending tasks by [running a TODO/FIXME report on the project root folder](https://www.mathworks.com/help/matlab/matlab_prog/add-reminders-to-files.html) (Again, this itself is a work in progress, so look out for that).

---

<b id="f1">1</b> I say "willing to", and not "capable of", because the latter requires merely that more time is spent on it, and the former is what is more important. [↩](#a1)

<b id="f2">2</b> which is meant to represent something that is "constant" in some sense. [↩](#a2)

<b id="f3">3</b> If `struct` arrays absolutely need to be used, `s` can be used to denote pluralization, since you can operate on the entire thing using [comma-separated lists](https://www.mathworks.com/help/matlab/matlab_prog/comma-separated-lists.html). [↩](#a3)
