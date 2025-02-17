# Configuração do ambiente em containers Linux

Caso você possua *docker* instalado, substitua todas as referências
à *podman* por *docker*. A sintaxe dos comandos continua a mesma para
os exemplos apresentados aqui.

## Gerenciamento de imagens

Para construir uma imagem, escolha um diretório contendo o Dockerfile
desejado (por exemplo, em linux-bare) e execute:

```
$ podman build -t linux-bare -f ./linux-bare/Dockerfile .
```

Para listar imagens instaladas:

```
$ podman image ls
```

Para remover a imagem (forçadamente):

```
$ podman rmi linux-bare --force
```

Para salvar uma imagem em um arquivo que pode ser carregado em outra máquina:

```
$ podman save linux-bare > linux-bare.tar
```

Para carregar uma imagem de um arquivo:

```
$ podman load < linux-bare.tar
```

## Gerenciamento de containers

Para listar containers em execução

```
$ podman container ls
```

Para executar um comando remoto

```
$ podman exec -it <container_name\> <command\>
```

Para copiar arquivos de um container

```
$ podman cp <container_name\>:/container/file/path/ /host/path/target
```


## Carregando uma instância de um container

As instâncias podem persistir seus dados no diretório local, e para isso
a flag *-v* está sendo utilizada. Todas as modificações realizadas dentro
do diretório */home* da instância serão preservados no diretório local
onde o comando *podman run* for executado. Para carregar uma instância,
em um terminal da máquina *host* digite:

```
$ podman run -v `pwd`:/home -p 8080:8080 linux-bare
```

Abrir um browser no *host* e acessar a URL "localhost:8080". A instância
também pode ser acessada pela rede, bastando substituir *localhost* pelo
IP da máquina executando a instância (neste caso, um servidor).

Muitas vezes será necessário realizar o acesso privilegiado à recursos
da máquina host. Por exemplo, para acesso privilegiado ao diretório */dev*,
será necessário adicionar algumas opções:

```
$ podman run -v `pwd`:/home -p 8080:8080 --privileged --cap-add=SYS_ADMIN -v /dev:/dev linux-bare
```


## Publicar uma imagem no ghcr.io

### Gerar um Personal Access Token

Inicialmente, você precisará gerar um token para realizar a autenticação,
sendo esse chamado de *personal access token* (PAT). Vá para a sua 
página do GitHub e clique no menu drop-down no topo direito da página. Lá,
escolha a opção *Settings*, e depois a opção *Developer Settings*, no canto
inferior esquerdo. Agora selecione *Personal access token* e de lá a opção
*Generate new token*.

No próximo passo, dê ao seu token um nome e escolha um tempo de expiração
de acordo com a sua necessidade. Marque a opção *write:packages* e depois
selecione *Generate token* na parte inferior da página. Lembre-se de copiar
o token, pois não haverá outra oportunidade no futuro.

### Logar em ghcr.io

O próximo passo é simples. Na linha de comando, deve-se autenticar no
*ghcr.io* utilizando o método de login tradicional. Seu nome de usuário
é o seu usuário no GitHub (ou sua organização) e sua senha é o *personal
access token* (PAT) gerado anteriormente. Em um login correto, você deverá
ver algo semelhante:

```
$ podman login ghcr.io
Username: <your GitHub username>
Password: <your personal access token>
Login Succeeded!
```

### Publicar imagens para ghcr.io

Uma vez que você estiver logado estará pronto para publicar imagens para
ghcr.io/<your GitHub username>/<your package name>. Por exemplo:

```
$ podman push myimage ghcr.io/sjohann81/myimage:latest
```

Por padrão, as imagens são publicadas de modo privado. Para que outros
usuários possam acessar a imagem, será necessário configurar permissões.
Vá para a sua página do GitHub e selecione a opção *Packages* e o pacote
desejado. Depois, no lado direito selecione a opção *Package settings*.
Na parte inferior da página (em Danger Zone), selecione *Change visibility*
e depois marque a opção *Public*.


## Carregar imagens publicadas no ghcr.io

Para carregar imagens publicadas anteriormente, basta utilizar o comando
*pull*, conforme o exemplo:

```
$ podman pull ghcr.io/sjohann81/myimage
```

## Gerenciamento do espaço em disco

O espaço ocupado na máquina *host* não é apenas limitado às imagens
disponíveis (que podem ser listadas com *podman image ls*, como dito
anteriormente). Para se ter uma ideia dos recursos utilizados, utilize
o comando:

```
$ podman system df
```

Caso deseje eliminar dados não utilizados, execute o comando:

```
$ podman system prune
```
