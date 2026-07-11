# .github

Configurações e infraestrutura compartilhada entre os repositórios de
disciplina de [@raphateixeira](https://github.com/raphateixeira).

## `assets/rtx-palette.scss`

Paleta de cores e variáveis SCSS institucionais, única fonte de verdade.
Cada repo de disciplina baixa a versão mais recente deste arquivo a cada
build (veja o workflow abaixo) e importa suas variáveis no próprio tema
local, mantendo apenas as customizações específicas daquele repo:

```scss
/*-- scss:defaults --*/
@import "rtx-palette";

/*-- scss:rules --*/
// overrides específicos deste repo (ex: reveal.js, fonte de código, etc.)
```

Para editar a paleta institucional, edite `assets/rtx-palette.scss` aqui —
não em cópias locais nos outros repos.

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
