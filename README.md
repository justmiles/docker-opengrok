docker run --rm -it \
  -e SRC_ROOT=/src \
  -e IGNORE_PATTERNS="-i *.jar -i *.so -i *.zip -i *.gz -i *.tar -i d:.git -i d:vendors -i d:log -i d:node_modules" \
  -p 8080:8080 \
  --name opengrok \
  justmiles/opengrok

docker exec -it opengrok /bin/ash