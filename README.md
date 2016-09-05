# RbdbcManager
[![Build Status](https://travis-ci.org/duck8823/rbdbc-manager.svg?branch=master)](https://travis-ci.org/duck8823/rbdbc-manager)
[![Coverage Status](http://coveralls.io/repos/github/duck8823/rbdbc-manager/badge.svg?branch=master)](https://coveralls.io/github/duck8823/rbdbc-manager?branch=master)
[![MIT License](http://img.shields.io/badge/license-MIT-blue.svg?style=flat)](LICENSE)  
  
blessしたリファレンスでデータベースを操作する  
  
## INSTALL
```sh
gem install specific_install
gem specific_install -l 'https://github.com/duck8823/rbdbc-manager.git'
```
  
## SYNOPSIS
```perl
require 'rbdbc'

# 構造体の定義
Hoge = Struct.new(:id, :name, :flg)

# データベースへの接続
manager = Rbdbc.connect('Pg', 'dbname=test;host=localhost', user='postgres')
# テーブルの作成
manager.create(Hoge.new(id=Integer, name=String, flg=TrueClass)).execute
# データの挿入
manager.insert(Hoge.new(1, 'name_1', true)).execute
manager.insert(Hoge.new(2, 'name_2', false)).execute
# データの取得（リスト）
rows = manager.from(Hoge).list
rows.each do |row|
	puts row
end
manager.from(Hoge).where(Where.new('name', 'name', Operator::LIKE)).list
# データの取得（一意）
row = manager.from(Hoge).where(Where.new('id', 1, Operator::EQUAL)).single_result
puts row
# データの削除
manager.from(Hoge).where(Where.new('id', 1, Operator::EQUAL)).delete.execute
# テーブルの削除
manager.drop(Hoge).execute
# SQLの取得
create_sql = manager.create(Hoge.new(id=Integer, name=String, flg=TrueClass)).get_sql
insert_sql = manager.insert(Hoge.new(1, 'name_1', true)).get_sql
delete_sql = manager.from(Hoge).where(Where.new('id', 1, Operator::EQUAL)).delete.get_sql
drop_sql = manager.drop(Hoge).get_sql
```

## License
MIT License