#!/bin/sh
# Copia o TemaRTx.scss canônico para cada repositório Quarto de GitRTx (as cópias locais não são
# versionadas: estão no .gitignore; o CI baixa a mesma versão a cada build).
#   ./atualizar-tema.sh          baixa a versão publicada (branch main do GitHub)
#   ./atualizar-tema.sh --local  usa .github/assets/TemaRTx.scss deste clone (para testar
#                                mudanças no tema em todos os repositórios antes de dar push)
cd "$(dirname "$0")/../.." || exit 1   # raiz de GitRTx (este script fica em .github/scripts/)
if [ "$1" = "--local" ]; then
  src=.github/assets/TemaRTx.scss
else
  src=/tmp/TemaRTx.canonico.scss
  curl -fsSL https://raw.githubusercontent.com/raphateixeira/.github/main/assets/TemaRTx.scss -o "$src" || exit 1
fi
for d in */; do
  d=${d%/}
  [ -f "$d/_quarto.yml" ] && [ "$d" != "raphateixeira.github.io" ] || continue
  cp "$src" "$d/TemaRTx.scss" && echo "tema atualizado: $d"
done
