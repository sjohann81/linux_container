# Configuração do ambiente em containers Linux

## Gerenciamento de imagens

Para construir uma imagem, executar:

- podman build -t linux_container .

Para remover a imagem (forçadamente):

- podman rmi linux_container --force


## Gerenciamento de containers

Para listar containers em execução

- podman container ls

Para executar um comando remoto

- podman exec -it <container_name\> <command\>

Para copiar arquivos de um container

- podman cp <container_name\>:/container/file/path/ /host/path/target


## Carregando uma instância

Em um terminal da máquina *host*:

- podman run -p 8080:8080 linux_container

Abrir um browser no *host* e acessar a URL "localhost:8080".
