//
//  AvatarEvolutionCard.swift
//  PocketBankKids
//
//  Created by Nazaret, Claiton Milton Augusto on 26/11/26.
//
import SwiftUI

struct AvatarEvolutionCard: View {
    let user: UserAccount
    
    var body: some View {
        VStack(spacing: 12) {
            HStack {
                Text(user.evolutionEmoji)
                    .font(.system(size: 56))
                    .padding(12)
                    .background(.yellow.opacity(0.25))
                    .clipShape(Circle())
                
                VStack(alignment: .leading, spacing: 4) {
                    Text("Nível \(user.level)")
                        .font(.caption.bold())
                        .padding(.horizontal, 8)
                        .padding(.vertical, 3)
                        .background(.orange)
                        .foregroundStyle(.white)
                        .clipShape(Capsule())
                    
                    Text(user.evolutionStageName)
                        .font(.headline)
                    
                    Text("\(user.xp) XP totais")
                        .font(.subheadline)
                        .foregroundStyle(.secondary)
                }
                Spacer()
            }
            
            VStack(alignment: .leading, spacing: 4) {
                ProgressView(value: user.xpProgressInCurrentLevel)
                    .tint(.orange)
                Text("Faltam \(100 - (user.xp % 100)) XP para a próxima evolução!")
                    .font(.caption2)
                    .foregroundStyle(.secondary)
            }
        }
        .padding()
        .background(Color(.secondarySystemGroupedBackground))
        .clipShape(RoundedRectangle(cornerRadius: 16))
        .shadow(color: .black.opacity(0.05), radius: 5, x: 0, y: 2)
    }
}
