mkdir -p ~/tools/vscode-cpptools
cd ~/tools/vscode-cpptools
wget https://github.com/microsoft/vscode-cpptools/releases/download/v1.12.4/cpptools-linux.vsix
unzip cpptools-linux.vsix

ln -sf ~/tools/vscode-cpptools/extension/debugAdapters/bin/OpenDebugAD7 ~/bin/OpenDebugAD7
chmod +x ~/tools/vscode-cpptools/extension/debugAdapters/bin/OpenDebugAD7
