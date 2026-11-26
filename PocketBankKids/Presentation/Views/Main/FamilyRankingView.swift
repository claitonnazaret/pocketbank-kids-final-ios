//
//  FamilyRankingView.swift
//  PocketBankKids
//
//  Created by Nazaret, Claiton Milton Augusto on 26/11/26.
//
import SwiftUI

struct FamilyMemberRank: Identifiable {
    let id = UUID()
    let name: String
    let emoji: String
    let xp: Int
    let isCurrentUser: Bool
}

struct FamilyRankingView: View {
    let currentUser: UserAccount
    
    var rankingList: [FamilyMemberRank] {
        let list = [
            FamilyMemberRank(
                name: "\(currentUser.name) (Você)",
                emoji: currentUser.evolutionEmoji,
                xp: currentUser.xp,
                isCurrentUser: true
            ),
            FamilyMemberRank(
                name: "Mamãe Clara",
                emoji: " 🦊 ",
                xp: 240,
                isCurrentUser: false
            ),
            FamilyMemberRank(
                name: "Papai Lucas",
                emoji: " 🐍 ",
                xp: 350,
                isCurrentUser: false
            ),
            FamilyMemberRank(
                name: "Irmã Sofia",
                emoji: " 🐣 ",
                xp: 120,
                isCurrentUser: false
            ),
            
        ]
        return list.sorted { $0.xp > $1.xp }
    }
    
    var body: some View {
        List(Array(rankingList.enumerated()), id: \.element.id) { index, member in
            HStack(spacing: 14) {
                Text("#\(index + 1)")
                    .font(.headline.bold())
                    .foregroundStyle(index == 0 ? .orange : .secondary)
                    .frame(width: 30)
                
                Text(member.emoji)
                    .font(.title)
                
                VStack(alignment: .leading) {
                    Text(member.name)
                        .font(.headline)
                        .foregroundStyle(member.isCurrentUser ? .orange : .primary)
                    Text("Nível \(max(1, (member.xp / 100) + 1))")
                        .font(.caption)
                        .foregroundStyle(.secondary)
                }
                
                Spacer()
                
                Text("\(member.xp) XP")
                    .font(.subheadline.bold())
                    .padding(.horizontal, 10)
                    .padding(.vertical, 4)
                    .background(member.isCurrentUser ? Color.orange.opacity(0.2) : Color.gray.opacity(0.15))
                    .clipShape(Capsule())
            }
        }
        .navigationTitle("Ranking Familiar 🏆")
        .navigationBarTitleDisplayMode(.inline)
    }
}
