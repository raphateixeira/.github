# .github

Configurações e infraestrutura compartilhada entre os repositórios de
disciplina de [@raphateixeira](https://github.com/raphateixeira).

## `assets/TemaRTx.scss`

Tema SCSS único (paleta, páginas HTML e apresentações revealjs), única
fonte de verdade para todos os repos de disciplina/pesquisa. Os repos **não
versionam** `TemaRTx.scss` (está no `.gitignore` de cada um): a cada build, o
workflow abaixo baixa a versão canônica daqui antes de renderizar, então a
versão publicada é sempre esta. Para o `quarto preview` local funcionar, cada
repo precisa do arquivo na raiz; `scripts/atualizar-tema.sh` (rodar a partir de
qualquer lugar) copia o tema para todos os repos de `GitRTx`.

Para editar o tema/paleta institucional, edite `assets/TemaRTx.scss` aqui —
não em cópias locais nos outros repos. Para testar antes de dar push, rode
`scripts/atualizar-tema.sh --local`.

## `.github/workflows/quarto-publish.yml`

Workflow reutilizável (`workflow_call`) que builda e publica um site Quarto
no GitHub Pages (via `actions/deploy-pages`, método de artifact — não usa
mais branch `gh-pages`). Cada repo de disciplina chama este workflow e só
declara as dependências que realmente usa. Exemplo mínimo
(`.github/workflows/publish.yml` no repo da disciplina):

```yaml
name: Publicar site

on:
  push:
    branches: [main]
  workflow_dispatch:

jobs:
  build-deploy:
    uses: raphateixeira/.github/.github/workflows/quarto-publish.yml@main
    with:
      needs_r: true
      r_packages: "knitr, rmarkdown, magick, pdftools"
      needs_magick_system_deps: true
      needs_tinytex: true
      tinytex_packages: "pgf pgfplots xcolor patterns"
```

Inputs disponíveis: `needs_python`, `python_version`, `python_packages`
(ignorado se houver `requirements.txt` no repo), `needs_r`, `r_version`,
`r_packages`, `needs_magick_system_deps`, `needs_pdf2svg`, `needs_tinytex`,
`tinytex_packages`, `output_dir` (padrão `_site`).

**Importante:** no GitHub, em Settings → Pages, a fonte precisa estar
configurada como "GitHub Actions" (não "Deploy from a branch").
