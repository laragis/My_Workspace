wget "https://github.com/ryanoasis/nerd-fonts/releases/download/v3.0.1/SourceCodePro.zip" &&\
unzip SourceCodePro.zip -d ./SourceCodePro &&  \
mv ./SourceCodePro/*.ttf /usr/local/share/fonts

fc-cache -fv