# Ika3

[![CircleCI](https://dl.circleci.com/status-badge/img/gh/YutaGoto/ika3/tree/main.svg?style=svg)](https://dl.circleci.com/status-badge/redirect/gh/YutaGoto/ika3/tree/main)

Weapon data from Splatoon3. This is Unofficial data.

## Installation

Install the gem and add to the application's Gemfile by executing:

    $ bundle add ika3

If bundler is not being used to manage dependencies, install the gem by executing:

    $ gem install ika3

## Usage

```ruby
require "ika3"
```

### Find Weapon data

```ruby
wakaba = Ika3::Weapon.find_by_name("わかばシューター")
=> {:name=>"わかばシューター", :sub=>"スプラボム", :special=>"グレートバリア"}

wakaba.special
=> "グレートバリア"
```

### Get Weapons from Sub-Weapon

```ruby
splatbombs = Ika3::Weapon.filter_by_sub("スプラボム")
splatbombs
=>
[{:name=>"わかばシューター", :sub=>"スプラボム", :special=>"グレートバリア"},
 {:name=>"スプラチャージャー", :sub=>"スプラボム", :special=>"キューインキ"},
 {:name=>"スプラスコープ", :sub=>"スプラボム", :special=>"キューインキ"},
 {:name=>"ノヴァブラスター", :sub=>"スプラボム", :special=>"ショクワンダー"},
 {:name=>"クラッシュブラスター", :sub=>"スプラボム", :special=>"ウルトラショット"},
 {:name=>"パブロ", :sub=>"スプラボム", :special=>"メガホンレーザー5.1ch"}]
```

## Note

This gem is NOT related to Nintendo.

The Schedule is used an unofficial API. <https://spla3.yuu26.com/>

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/YutaGoto/ika3.

## License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).
