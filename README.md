
emacs.d
========

my emacs configuration.  
Mainly for:  
C++  
javascript  
org  
org-page for blog

����emacs��������࣬�ҹ����Ļ�����vs2012,ʹ����vsvim��vassistx,���ǱȽ�������ʹ�÷�ʽ��������IDE�ͱ༭�����Ե����ƣ�
���ڲ������ڵ�����˵��һ�������Ľ��������������һֱ��ѹ��������л���MAC����Linux�£���ϣ����MAC), ����һֱ������emacs�����á�
emacs�����IDE����ȱ������Ŀ����ͻ���������ļ���ת���Զ���ȫ(����ʲô�����߼��ʣ���Щ�˸����Ͳ��õ�����)������Ӱ��ʵ�������Ī���ں���������ļ���ת��֮ǰֻ����cscope,������Щ����ctags����gtags���ļ���ת�ܲ�����������һЩ��Update()֮�������ͨ�ú�����������ת��ȥ�ǻ����˵ģ�֮ǰҲ��cedet���������������Ŀ���Ǻܾ�û��ά���ˣ��汾�Ͼ��Ұ�װ�鷳�������Ҿ�һֱû��˳�ֹ������Ҷ��ڴ���Ŀ��Ч��Ҳ�Ǻܵ͵ģ��������Զ���ȫҲ�ǣ�֮ǰҲ����ֻ���ҵ������ı��Ĳ�ȫ���ù������ҵ���auto-complete-clang�����������ã����Ǵ���Ŀ��Ч�ʻ���̫���ˣ�һֱ����������Թ����ź�����һֱֻ�ǰ�emacs��Ϊһ����ͨ���ı��༭����windows�����ڸĸ������ļ���дcmake,org���ĵ�����dired�����ļ���������Ϊ�ն�ʹ��(��Ϊ�ն���windows���и����Ƶ�����һֱû����ľ�����������Щ�����޷����ԣ���mysql��ЩҪ�������������޷�ʹ��)��  
     ���Ǿ�����ô��ʱ���̽�����������ڽ���ˣ��������ҵ����õĹ�����ΪC++�Ŀ����������ؼ��Ĳ�����ǣ�Rtags��emacs-clang-complete-async,����������ǻ���clang�����ļ��ģ�ǰһ���������ļ���ת�ģ���һ�����Զ���ȫ�����������첽�ĵ����߳����Բ����п������������ļ���Ҫ�Ƕ���mac�ģ���ֻ��windows��mac��;��ϵͳ��linuxû���κεĲ��ԣ�������linux���ǿ��еġ�  
����˵˵��������İ�װ��  
rtags:https://github.com/Andersbakken/rtags  
git clone  --recursive https://github.com/Andersbakken/rtags.git  
��װllvm:  
brew search llvm  
�ҵ�brew�������µ�llvm�汾:�ҵİ汾��llvm35,  
��װ��  
brew install llvm35 --with-clang --with-libcxx --rtti  
Ȼ��cd��rtags�ĸ�Ŀ¼��  
cmake .  
make  
��������rtags/bin��������rtags�Ŀ�ִ���ļ�����Ҫ��rdm ��rc  
������Ϊ�����û���������  
  
export PATH=/path/to/rtags/src:~/bin/:$PATH  
ln -s /path/to/rtags/gcc-rtags-wrapper.sh ~/bin/c++  
ln -s /path/to/rtags/gcc-rtags-wrapper.sh ~/bin/cc  
ln -s /path/to/rtags/gcc-rtags-wrapper.sh ~/bin/g++  
ln -s /path/to/rtags/gcc-rtags-wrapper.sh ~/bin/gcc  
ע��rtags��Ŀ¼������path��ǰ�棬  
ʹ��which -a gcc ��������ʾ����gcc �����~/bin/gccҪ��ǰ�棬  
��makefile������������ʹ��gcc������������ʱ��  
ϵͳ�����path�еĵ�һ��gcc���Ȼ��gcc_rtags_wrapper.sh�ͻ���ú����ϵͳԭ����gcc���  
����rtags��װ���ˣ��õ�ʱ��Ҫ��rdm�ĺ�̨���򣬵���һ�㶼����emacs��elisp�ļ������Բ���Ҫ�Լ��ֶ�����������.  
�������ҵ����ã�  
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
�������ú�emacs���ڴ�c/c++�ļ���ʱ���Զ�����rdm�ĺ�̨����һ��ֻҪ��f5����һ��rtagsӦ�þͿ����������ˣ�M-g M-gת�����壬M-g-r�����������ã�M-g f/b ��ջ��ǰ����ת  
M-g o ��cpp/h ���л���  
����emacs����������ļ���ת�͸㶨�ˡ�  
�������Զ���ȫ�ģ�  
emacs-clang-complete-async:https://github.com/Golevka/emacs-clang-complete-async  
  
git clone https://github.com/Golevka/emacs-clang-complete-async.git  
��¡����֮��Ҫ��makefile������LLVM_CONFIG��ֵ��Ĭ����llvm-config������mac��װ��llvm�����涼���һ���汾�ţ�����Ҫ�޸�һ�¡�  
Ȼ���������make��  
��������make֮������clang-complete�Ŀ�ִ���ļ�������ֱ�����л���ʾ�޷�����@rpath/llvmXXX֮��Ŀ⣬���������˺ó�ʱ����ҵ�ԭ��  
����취��  
��makefile.mk�ļ��е�39 ��  
$(LINK.c) $^ $(LDLIBS)�� ���� -rpath /usr/local/Cellar/llvm35/3.5.0/lib/llvm-3.5/lib  
����ľ���·��������Ӧ��������ģ�������llvm-config --libdir�鿴��  
���úú���emacs�����ã�  
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
������auto-complete�ĺ�ѡ�о���clang�ṩ�Ĳ�ȫ��  
  
�����ҵ������ļ���  
���ù��ܶ��˵������ļ������ڵ�����汾Ҳ�ǻ������˵ģ������еĺܶ�wttr/��ͷ�ĺ������ǶԷ�д�ģ��ṹ���ҿ�������������Խ������ģ�����һֱ���á�  
�����ļ��Ľṹ��  
.emacs.d/plugins ��Ų����λ�á�  
.emacs.d/wttr-config����Ҫ�����ļ���λ�á�  
����  
wttr-basic.el��һЩ�������ã�����emacs��shell�ж�����path�����ã�Ҳ����exec-path������C-c C-y ����һ�У�C-M-\\��������buffer��  
wttr-font.el�����壬wttr-color-theme.el�������ⱳ����wttr-key.el�ǰ������ã��ǲ����صİ����󶨶������wttr-mode-line.el����emacs�������������Ϣ������ʾ������ļ�д�ĺܺ�,������nyan-mode�ʺ������ļ����룬�ȶ���ʵ�á�  
wttr-utils.el�������Լ�д��һЩ����������ϵͳ�����жϣ�����·����load-path,����ʵ�á�  
wttr-modes.el�ǲ������ѡ����ļ���ԭʼ�汾�Ǽ���.emacs.d/wttr-config/modes/�ļ����°���������ƴ�����Ӧ�������ļ���Ȼ����wttr-modes.el����ɨ�赽��modes/�����������ļ����Ұ����ĳ��˸��ݲ�ͬ��ϵͳ��������Ҫ�Ĳ����  
