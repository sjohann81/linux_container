# Configuração do ambiente em containers Linux

## Gerenciamento de imagens

Para construir uma imagem, escolha um diretório contendo o Dockerfile
desejado (por exemplo, em linux-bare) e execute:

- podman build -t linux-bare -f ./linux-bare/Dockerfile .

Para listar imagens instaladas:

- podman image ls

Para remover a imagem (forçadamente):

- podman rmi linux-bare --force

Para salvar uma imagem em um arquivo que pode ser carregado em outra máquina:

- podman save linux-bare > linux-bare.tar

Para carregar uma imagem de um arquivo:

- podman load < linux-bare.tar

## Gerenciamento de containers

Para listar containers em execução

- podman container ls

Para executar um comando remoto

- podman exec -it <container_name\> <command\>

Para copiar arquivos de um container

- podman cp <container_name\>:/container/file/path/ /host/path/target


## Carregando uma instância

As instâncias podem persistir seus dados no diretório local, e para isso
a flag *-v* está sendo utilizada. Todas as modificações realizadas dentro
do diretório */home* da instância serão preservados no diretório local
onde o comando *podman run* for executado. Para carregar uma instância,
em um terminal da máquina *host* digite:

- podman run -v `pwd`:/home -p 8080:8080 linux-bare

Abrir um browser no *host* e acessar a URL "localhost:8080". A instância
também pode ser acessada pela rede, bastando substituir *localhost* pelo
IP da máquina executando a instância (neste caso, um servidor).
