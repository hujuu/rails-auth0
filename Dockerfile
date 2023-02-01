FROM --platform=linux/x86_64 ruby:3.1

#環境変数
ENV APP="/myapp" \
        CONTAINER_ROOT="./"

#ライブラリのインストール
RUN apt-get update && apt-get install -y \
        nodejs \
        mariadb-client \
        build-essential \
        wget \
        yarn 

# 実行するディレクトリの指定
WORKDIR $APP
COPY Gemfile Gemfile.lock $CONTAINER_ROOT
RUN bundle install
## ↓ここが懸念点（開発環境ではCOPYをしたくないが、本番環境でする必要があるため、この記述）
COPY . .

# DB関連の実行
COPY entrypoint.sh /usr/bin/
RUN chmod +x /usr/bin/entrypoint.sh
ENTRYPOINT ["entrypoint.sh"]

# 以下の記述があることでnginxから見ることができる
VOLUME ["/myapp/public"]
VOLUME ["/myapp/tmp"]

# railsアプリ起動コマンド
CMD ["unicorn", "-p", "3000", "-c", "/myapp/config/unicorn.rb", "-E", "$RAILS_ENV"]
