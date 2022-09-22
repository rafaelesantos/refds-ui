# RefdsUI

> **RefdsUI** é uma biblioteca de componentes SwiftUI que fornece aos desenvolvedores a maneira mais fácil possível de criar novas telas para suas aplicações.

[![Swift Version][swift-image]][swift-url]
[![License][license-image]][license-url]

### Qual a utilidade do RefdsUI ?

O **RefdsUI** é um *Design System*, ou seja, uma coleção de componentes reutilizáveis, padronizados para determinado produto. Diferente de um style guide (guia de estilos), um design system vai além: o design system unifica a linguagem de um determinado produto.

Encare o **RefdsUI** não como um projeto, mas como um produto interno da empresa, que precisa de pessoas que o atualizem enquanto desenvolvem soluções novas, novos componentes, novos guias de estilo. De botões arredondados e snippets de códigos à concepções de aplicação de marca, tom de voz de texto e o microcopy.

Essa biblioteca permite que você integre o sistema de design **RefdsUI** ao seu projeto iOS SwiftUI.

### Instalação

Adicione esse projeto em seu arquivo `Package.swift`.

```swift
import PackageDescription

let package = Package(
    dependencies: [
        .package(url: "https://github.com/rafaelesantos/refds-ui.git", branch: "main")
    ],
    targets: [
        .target(
            name: "YourProject",
            dependencies: ["RefdsUI"]),
    ]
)
```

[swift-image]: https://img.shields.io/badge/swift-5.7-orange.svg
[swift-url]: https://www.swift.org/blog/swift-5.7-released/
[license-image]: https://img.shields.io/badge/License-MIT-blue.svg
[license-url]: LICENSE
