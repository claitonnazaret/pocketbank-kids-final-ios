# 🐷 PocketBank Kids

**Educação financeira gamificada para crianças.**  
O **PocketBank Kids** transforma o ato de poupar em uma jornada estilo RPG: a cada depósito no cofrinho ou missão concluída, a criança ganha **XP**, sobe de nível e vê seu **Avatar evoluir** visualmente.

---

## 🎯 Funcionalidades Implementadas (7 Telas)

1. **Login e Cadastro (`AuthView`)**: Criação de conta infantil com escolha de perfil/avatar inicial e autenticação persistida via SwiftData.
2. **Dashboard / Cofrinho (`DashboardView`)**: Exibição do saldo total, barra de XP, evolução dinâmica do avatar (Ovo -> Porquinho Aprendiz -> Guardião Dourado -> Mestre das Moedas), atalhos rápidos e metas ativas.
3. **Extrato / Histórico (`HistoryView`)**: Listagem cronológica de depósitos, conclusões de metas e recompensas de missões com filtro por categoria (`Todos`, `Depósitos`, `Missões`).
4. **Cadastro de Meta / Depósito (`AddGoalOrDepositView`)**: Modal para criar novas metas financeiras (ex: Bicicleta, Videogame) ou adicionar dinheiro ao cofrinho.
5. **Detalhe e Conclusão de Meta (`GoalDetailView`)**: Visualização detalhada do progresso da meta, aporte rápido e resgate com celebração de XP.
6. **Missões e Recompensas (`MissionsView`)**: Consumo de API REST externa (`URLSession` + `Codable`) exibindo tarefas financeiras e educativas com estados de *Loading*, *Sucesso*, *Erro* e *Vazio*.
7. **Ranking Familiar (`FamilyRankingView`)**: Placar comparativo entre a criança e familiares fictícios/cadastrados baseado no XP acumulado.

---

## 🏗️ Arquitetura e Tecnologias

- **Linguagem & UI**: Swift 5.9+ / SwiftUI (iOS 17.0+)
- **Arquitetura**: **MVVM** (Model-View-ViewModel) com **Repository Pattern**, **Injeção de Dependência** e **Fluxo de Dados Unidirecional**.
- **Navegação**: `NavigationStack` centralizado com `AppRouter` (`NavigationPath` tipado) e `.sheet` modais.
- **Persistência Local**: **SwiftData** (`@Model`, `ModelContainer`, `ModelContext`) garantindo funcionamento 100% offline-first.
- **Rede / API**: `URLSession` assíncrono (`async/await`) + `Codable` consumindo endpoint JSON público (JSONPlaceholder adaptado para missões) com tratamento de falhas.

---

## 🚀 Instruções de Execução

1. Abra o **Xcode 15+** (ou superior).
2. Selecione **File > New > Project > iOS > App**.
3. Configure:
   - **Product Name**: `PocketBankKids`
   - **Interface**: `SwiftUI`
   - **Storage**: `SwiftData`
4. Substitua o código gerado pelos arquivos organizados nas pastas `App`, `Domain`, `Data` e `Presentation`.
5. Selecione um simulador com **iOS 17.0 ou superior** (ex: iPhone 15 / 16) e pressione **`Cmd + R`**.

---

## 👥 Integrantes
- Claiton Nazaret (claitonnazaret@gmail.com)— Desenvolvimento iOS, SwiftUI, SwiftData & Arquitetura MVVM-
- Glauciany Brandao dos Santos (glauciany.a.santos@capgemini.com) — Desenvolvimento iOS, SwiftUI, SwiftData & Arquitetura MVVM
- Thiago Servio Benedicto (thiago.benedicto@capgemini.com) — Desenvolvimento iOS, SwiftUI, SwiftData & Arquitetura MVVM
- Josemberg Sousa Duarte (josembergsduarte@gmail.com) — Desenvolvimento iOS, SwiftUI, SwiftData & Arquitetura MVVM

