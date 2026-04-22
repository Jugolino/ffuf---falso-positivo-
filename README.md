# FFUF Bonito

Wrapper em `bash` para o `ffuf` com foco em terminal:

- aceita apenas `URL` e `wordlist` para começar;
- melhora a visualização dos resultados;
- separa `PROVAVEIS FALSOS POSITIVOS` e `POSITIVOS`;
- usa agrupamento por `status + size` para destacar respostas repetidas;
- mostra um resumo final com os grupos de tamanho mais repetidos.

## Visao Geral

Repositorio:

- GitHub: `https://github.com/Jugolino/FFUF_BONITO`
- Script: `https://github.com/Jugolino/FFUF_BONITO/blob/main/script`

O `ffuf` puro e excelente, mas a saida pode ficar cansativa quando o alvo devolve muitas respostas parecidas. Este script tenta organizar melhor o resultado no terminal e priorizar o que merece revisao manual.

O fluxo e simples:

1. voce informa uma `URL` e uma `wordlist`;
2. se a URL nao tiver `FUZZ`, o script adiciona `/FUZZ` automaticamente;
3. o `ffuf` roda normalmente;
4. no final, o script reclassifica a saida em:
   - `PROVAVEIS FALSOS POSITIVOS`
   - `POSITIVOS`

## Funcionalidades

- Wrapper unico em `bash`
- Saida colorida no terminal
- URLs em destaque
- Agrupamento por status HTTP
- Heuristica simples por `status + size`
- Resumo final com contagem por status
- Lista dos grupos `status,size` mais repetidos
- Defaults de velocidade aplicados automaticamente quando voce nao passa parametros

## Dependencias

Voce precisa ter:

- `ffuf`
- `python3`
- shell `bash`


## Como Usar

Uso basico:

```bash
./script https://example.com /caminho/wordlist.txt
```

Se a URL nao tiver `FUZZ`, o script transforma:

```text
https://example.com
```

em:

```text
https://example.com/FUZZ
```

Uso com parametros extras do `ffuf`:

```bash
./script https://example.com/FUZZ /caminho/wordlist.txt -fc 404 -mc all
```

## Defaults Automaticos

Se voce nao informar manualmente, o script aplica:

```bash
-rate 12
-p 0.05
-t 30
```

Se quiser sobrescrever, basta passar seus proprios valores:

```bash
./script https://example.com lista.txt -rate 5 -p 0.2 -t 10
```

## Como Baixar

### Opcao 1: clonar o repositorio

```bash
git clone https://github.com/Jugolino/FFUF_BONITO.git
cd FFUF_BONITO
chmod +x script install.sh
```

### Opcao 2: baixar como ZIP

1. abra o repositorio no GitHub;
2. clique em `Code`;
3. clique em `Download ZIP`;
4. extraia os arquivos;
5. entre na pasta e execute o script.

## Como Instalar

O arquivo `install.sh` instala o script em `~/.local/bin` por padrao com o nome `ffuf-bonito`.

```bash
chmod +x install.sh
./install.sh
```

Instalacao direta via GitHub:

```bash
curl -fsSL https://raw.githubusercontent.com/Jugolino/FFUF_BONITO/main/install.sh -o install.sh
chmod +x install.sh
./install.sh
```

Instalacao em uma linha:

```bash
curl -fsSL https://raw.githubusercontent.com/Jugolino/FFUF_BONITO/main/install.sh | bash
```

Instalar em outro diretorio:

```bash
./install.sh /usr/local/bin
```

Instalar com outro nome:

```bash
./install.sh ~/.local/bin meu-ffuf
```

Depois disso, voce pode chamar:

```bash
ffuf-bonito https://example.com /caminho/wordlist.txt
```

## Exemplo de Saida

```text
======================== PROVAVEIS FALSOS POSITIVOS ========================

HTTP 403 (120 itens)
FP [403] https://target.tld/random-path
   size 5487    words 112    lines 2      time 21000.0ms

=============================== POSITIVOS ==================================

HTTP 200 (3 itens)
OK [200] https://target.tld/admin
   size 9211    words 430    lines 88     time 1700.0ms
```

## Limites da Heuristica

Este projeto nao tenta adivinhar com precisao absoluta o que e valido. Ele apenas reorganiza a saida para facilitar a revisao.

Alvos que devolvem:

- `403` padrao para muitos caminhos;
- `404` customizado com o mesmo layout;
- redirecionamentos parecidos;

podem continuar exigindo validacao manual.


