# treeicons.sh

A tree with icons

<img src="./screenshot1.png">

<p align="center">
<a href="https://github.com/eylles/treeicons.sh" alt="GitHub"><img src="https://img.shields.io/badge/Github-2B3137?style=for-the-badge&logo=Github&logoColor=FFFFFF"></a>
<a href="https://gitlab.com/eylles/treeicons.sh" alt="GitLab"><img src="https://img.shields.io/badge/Gitlab-380D75?style=for-the-badge&logo=Gitlab"></a>
<a href="https://codeberg.org/eylles/treeicons.sh" alt="CodeBerg"><img src="https://img.shields.io/badge/Codeberg-2185D0?style=for-the-badge&logo=codeberg&logoColor=F2F8FC"></a>
</p>

## why ?

I wanted to have tree with icons.


## usage

Just run make to install or uninstall, all this depends on is a shell interpreter and  tree.

View the available options with:

```sh
treeicons -h
```

To use inside vifm add this to your vifmrc:

```
" Directories
fileviewer */ treeicons -l %ph %f
fileviewer .*/ treeicons -l %ph %f
```
