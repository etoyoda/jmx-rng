# jmx-rng
practical RNG schema for JMA XML

気象庁では2011年5月から「気象庁防災情報XML」という形式での情報提供をしています。
利用者に取り扱いやすくするため、というので、
技術的に意味が通るように言い換えるならば、
従来の「かな漢字電文」で様々な情報をShift_JISプレーンテキストに落とし込んで提供していて、利用者側ではアドホックな分析処理を必要としていたのを、
新たにスキーマの明確なXMLを採用することにより改善した、ということなのでしょう。

その意図は、もちろんある程度は達成された一方で、まだまだ利用者側の分析処理の負担軽減のためにできることがあるように思います。
その最たるものが、XMLスキーマを適切に制約し、機械可読に提供し、構造と意味の対応付けを明確化することです。

XMLスキーマはXML要素や属性について、どのような名前のものがどのような順番・包含関係で何個現れうるか（あるいは必ず現れるか）を記述したものです。
XMLデータを読む側にしてみれば、解読結果を格納するデータ構造としてどんなものを用意したらいいのかを、そこで知るわけですね。
