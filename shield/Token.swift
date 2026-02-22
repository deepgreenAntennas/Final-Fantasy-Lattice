//
//  Token.swift
//  shield
//
//  Created by Dr. Nathaniel Fox on 2/19/26.
//

import CryptoTokenKit

class Token: TKToken, TKTokenDelegate {

    func createSession(_ token: TKToken) throws -> TKTokenSession {
        return TokenSession(token:self)
    }

}
