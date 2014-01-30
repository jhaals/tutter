# Tutter (WIP)
Tutter is a “pluggable” Github merge bot. Use it to ensure custom rules and validation for your Github project

Tutter monitors pull requests in your Github project and can allow automatic merging based on
your ACL's or preferences

The default validator that's shipped with tutter allow anyone to merge a commit that has a +1 comment by more then two people. The commit can be merged by adding a comment that says !merge

    Default validator workflow:
    Pull Request -> Built automatically by Jenkins -> Jenkins Says OK ->
    User X says +1 -> User Y +1 -> Anyone says !merge -> Tutter merges

#  Features
* Pluggable with custom validators
* Supports multiple projects

## Features to implement
* Add Web hooks in Github automatically
