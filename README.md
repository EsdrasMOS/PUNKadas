**PUNKadas**

**PUNKadas** é um jogo de luta 2D desenvolvido em **Processing (Java)**, focado em batalhas locais entre dois jogadores. O jogo mistura combate arcade com mecânicas simples de movimentação, ataque, knockback e sprites animados, trazendo uma experiência caótica no melhor estilo "quem apertar mais rápido vence".

## Sobre o jogo

Em **PUNKadas**, dois jogadores entram em combate usando personagens únicos com ataques expansivos, barras de vida e física básica aplicada nos movimentos. O objetivo é zerar a vida do adversário antes de ser derrotado.

### Funcionalidades implementadas:
- Sistema de movimento horizontal
- Gravidade e pulo
- Ataques corpo a corpo com alcance variável
- Sistema de dano
- Knockback após golpes
- Barras de vida dinâmicas
- Sprites para:
  - Idle (parado)
  - Movimento
  - Ataque
- Colisão entre jogadores
- Tela de Game Over
- Reinício da partida
- Combate local multiplayer (2 jogadores)

---

## Controles

### Jogador 1
| Ação | Tecla |
|------|--------|
| Andar esquerda | `A` |
| Andar direita | `D` |
| Pular | `W` |
| Atacar | `Espaço` |

### Jogador 2
| Ação | Tecla |
|------|--------|
| Andar esquerda | `←` |
| Andar direita | `→` |
| Pular | `↑` |
| Atacar | `Enter` |

### Sistema
| Ação | Tecla |
|------|--------|
| Reiniciar partida | `R` |

---

## Mecânicas

### Sistema de combate
Os ataques possuem:
- Alcance progressivo
- Cooldown entre golpes
- Aplicação de dano
- Empurrão (knockback)

Cada golpe reduz a vida do inimigo até chegar a **0 HP**, encerrando a partida.

---

## Como executar
Instale o Processing
Clone o repositório:
git clone https://github.com/seuusuario/punkadas.git
Abra o arquivo .pde
Adicione as sprites na pasta data
Execute

---

## Estrutura de sprites

O projeto utiliza sprites separadas para estados do personagem:

```txt
sprite1_player1.png → Idle
sprite2_player1.png → Movimento
sprite3_player1.png → Ataque

sprite1_player2.png → Idle
sprite2_player2.png → Movimento
sprite3_player2.png → Ataque

