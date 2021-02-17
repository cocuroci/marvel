# Objetivo

Criar um aplicativo que mostre uma lista de personagens da Marvel. 

Além da lista o aplicativo contém: 
- Busca  por nome
- Detalhes do personagem
- Favoritar personagem
- Disponibilizar os favoritos de forma offline.

## Arquitetura

Foi utilizado uma arquitetura baseada em VIP:

### Interactor

Camada responsável pela lógica da funcionalidade.

### Presenter

Camada responsável por transformar os dados do interactor para a view.

### ViewController

Camada responsável pelo layout.

### Factory
Camada responsável para criar a cena e configurar as outras camadas.

### Service
Camada responsável pelas requisições.

## Libs utilzadas

- Kingfisher (requisição das imagens em background)
- Moya (Camada de requisições)

Utilizei o Moya para facilitar a criação das requisições para as APIs.

## Detalhes do projeto

- A implementação dos erros foi feita de forma genérica para facilitar o desenvolvimento.
- Existe um arquivo chamado `Environment.swift` que contém a apiKey e privateKey da API da Marvel.  (necessário atualizar essas variávels para que o app funcione)

## To Do

- Criar paginação na lista de personagens
- Poder favoritar na lista da busca de personagens
- Salvar as informações dos personagens favoritados em um banco de dados
- Sincronizar os dados salvos no iCloud
