
emacs.d
========

my emacs configuration.  
Mainly for:  
C++  
javascript  
org  
org-page for blog

用了emacs已有两年多，我工作的环境是vs2012,使用了vsvim和vassistx,算是比较完美是使用方式，集成了IDE和编辑器各自的优势，
对于不想折腾的人来说是一个完美的解决方案，但是我一直想把工作环境切换到MAC或者Linux下（更希望是MAC), 所以一直在折腾emacs的配置。
emacs相对于IDE最大的缺点是项目管理和基于语义的文件跳转和自动补全(调试什么的仁者见仁，有些人根本就不用调试器)，而最影响实际体验的莫过于后两项，对于文件跳转，之前只有像cscope,但是这些基于ctags或者gtags的文件跳转很不给力，遇到一些像Update()之类的这种通用函数，你想跳转过去是会死人的，之前也有cedet这样基于语义的项目但是很久没有维护了，版本老旧且安装麻烦，反正我就一直没搞顺手过，而且对于大项目的效率也是很低的，；对于自动补全也是，之前也基本只能找到基于文本的补全，用过后来找到了auto-complete-clang，基本可以用，但是大项目的效率还是太低了，一直带着这样的怨念和遗憾，我一直只是把emacs作为一个普通的文本编辑器在windows下用于改改配置文件，写cmake,org等文档，用dired管理文件，或者作为终端使用(作为终端在windows下有个郁闷的问题一直没解决的就是命令行有些命令无法回显，想mysql这些要输入密码的命令都无法使用)。  
     但是经过这么长时间的探索，问题终于解决了，我终于找到好用的工具作为C++的开发环境，关键的插件就是：Rtags和emacs-clang-complete-async,两个插件都是基于clang解析文件的，前一个是用于文件跳转的，后一个是自动补全，两个都是异步的调用线程所以不会有卡顿现象，配置文件主要是对于mac的，我只有windows和mac两;个系统，linux没有任何的测试，理论上linux下是可行的。  
下面说说两个插件的安装：  
rtags:https://github.com/Andersbakken/rtags  
git clone  --recursive https://github.com/Andersbakken/rtags.git  
安装llvm:  
brew search llvm  
找到brew库中最新的llvm版本:我的版本是llvm35,  
安装：  
brew install llvm35 --with-clang --with-libcxx --rtti  
然后cd到rtags的根目录：  
cmake .  
make  
这样就在rtags/bin下生成了rtags的可执行文件，主要是rdm 和rc  
下面是为了设置环境变量：  
  
export PATH=/path/to/rtags/src:~/bin/:$PATH  
ln -s /path/to/rtags/gcc-rtags-wrapper.sh ~/bin/c++  
ln -s /path/to/rtags/gcc-rtags-wrapper.sh ~/bin/cc  
ln -s /path/to/rtags/gcc-rtags-wrapper.sh ~/bin/g++  
ln -s /path/to/rtags/gcc-rtags-wrapper.sh ~/bin/gcc  
注意rtags的目录必须在path的前面，  
使用which -a gcc 后腰能显示两个gcc 的命令，~/bin/gcc要在前面，  
在makefile或者命令行里使用gcc或者其他命令时，  
系统会调用path中的第一个gcc命令，然后gcc_rtags_wrapper.sh就会调用后面的系统原本的gcc命令。  
这样rtags就装好了，用的时候要打开rdm的后台程序，但是一般都是用emacs的elisp文件，所以不需要自己手动输入命令行.  
下面是我的配置：  
(wttr/plugin:prepend-to-load-path "rtags/src/")  
(global-unset-key (kbd "M-g M-g"))  
(global-set-key (kbd "M-g M-g") 'rtags-find-symbol-at-point)  
(global-set-key (kbd "M-g f") 'rtags-location-stack-forward)  
(global-set-key (kbd "M-g b") 'rtags-location-stack-back)  
(global-set-key (kbd "M-g r") 'rtags-find-references-at-point)  
(defun my-compile-func()  
  (interactive)  
  (save-buffer)  
  (recompile))  
   
(commandp 'cc-hook-func)  
(defun cc-hook-func()  
  (local-set-key (kbd "M-g o") 'ff-find-other-file)  
  (rtags-start-process-maybe)  
  (local-set-key (kbd "<f5>") 'my-compile-func))  
(add-hook 'c-mode-common-hook 'cc-hook-func)  
  
(require 'rtags)  
这样配置后，emacs会在打开c/c++文件的时候自动开启rdm的后台程序，一般只要按f5编译一遍rtags应该就可以起作用了，M-g M-g转到定义，M-g-r查找所有引用，M-g f/b 在栈中前后跳转  
M-g o 在cpp/h 中切换。  
这样emacs基于语义的文件跳转就搞定了。  
下面是自动补全的：  
emacs-clang-complete-async:https://github.com/Golevka/emacs-clang-complete-async  
  
git clone https://github.com/Golevka/emacs-clang-complete-async.git  
克隆下来之后要在makefile里设置LLVM_CONFIG的值，默认是llvm-config，但是mac安装的llvm，后面都会跟一个版本号，所以要修改一下。  
然后就是运行make。  
我在运行make之后会产生clang-complete的可执行文件，但是直接运行会提示无法加载@rpath/llvmXXX之类的库，网上搜索了好长时间才找到原因。  
解决办法：  
在makefile.mk文件中的39 行  
$(LINK.c) $^ $(LDLIBS)后 加了 -rpath /usr/local/Cellar/llvm35/3.5.0/lib/llvm-3.5/lib  
后面的具体路径根据相应的情况更改，可以用llvm-config --libdir查看。  
设置好后在emacs中配置：  
      (wttr/plugin:prepend-to-load-path "clang-async")  
      (require 'auto-complete-clang-async)  
      (defun ac-cc-mode-setup ()  
        (interactive)  
        (setq ac-clang-complete-executable "~/.emacs.d/plugins/clang-async/clang-complete")  
        (setq ac-sources '(ac-source-clang-async ac-source-yasnippet ac-source-variables))  
        ;;  (setq ac-sources (append '(ac-source-clang-async ac-source-yasnippet) ac-sources))  
        ;;  (setq ac-sources '(ac-source-clang-async ac-source-yasnippet ac-source-words-in-all-buffer ac-source-functions ac-source-words-in-all-buffer))  
        (ac-clang-launch-completion-process))  
        (add-hook 'c-mode-common-hook 'ac-cc-mode-setup)  
        (add-hook 'auto-complete-mode-hook 'ac-common-setup)  
        (global-auto-complete-mode t))  
这样在auto-complete的后选中就有clang提供的补全了  
  
关于我的配置文件：  
我用过很多人的配置文件，现在的这个版本也是基于他人的，配置中的很多wttr/开头的函数都是对方写的，结构是我看过的配置中相对较清晰的，所以一直在用。  
配置文件的结构：  
.emacs.d/plugins 存放插件的位置。  
.emacs.d/wttr-config是主要配置文件的位置。  
其中  
wttr-basic.el是一些基本设置，包括emacs的shell中独立的path的设置，也就是exec-path，还有C-c C-y 复制一行，C-M-\\缩进整个buffer。  
wttr-font.el是字体，wttr-color-theme.el设置主题背景，wttr-key.el是按键设置，非插件相关的按键绑定都在这里，wttr-mode-line.el就是emacs最下面的那条信息栏的显示，这个文件写的很好,包括了nyan-mode彩虹条，文件编码，等都很实用。  
wttr-utils.el是作者自己写的一些函数，包括系统类型判断，加载路径到load-path,都很实用。  
wttr-modes.el是插件加载选择的文件，原始版本是记载.emacs.d/wttr-config/modes/文件夹下按插件的名称创建响应的配置文件，然后在wttr-modes.el加载扫描到的modes/中所有配置文件，我把它改成了根据不同的系统加载我需要的插件。  
