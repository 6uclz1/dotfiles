
if [ ~/.zlogin -nt ~/.zlogin.zwc ]; then
   zcompile ~/.zlogin
   echo 'zlogin compiled!'
fi

if [ ~/.zshenv -nt ~/.zshenv.zwc ]; then
   zcompile ~/.zshenv
   echo 'zshenv compiled!'
fi

if [ ~/.zshrc -nt ~/.zshrc.zwc ]; then
   zcompile ~/.zshrc
   echo 'zshrc compiled!'
fi
