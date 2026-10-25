package com.techgear.model;

import java.time.LocalDateTime;

/** Shared model contract; coordinate field changes with the whole team. */
public class PasswordResetToken {
    private int tokenId;
    private int userId;
    private String tokenHash;
    private LocalDateTime expiresAt;
    private boolean used;
    private LocalDateTime createdAt;

    public PasswordResetToken() { }

    public PasswordResetToken(int tokenId, int userId, String tokenHash, LocalDateTime expiresAt, boolean used, LocalDateTime createdAt) {
        this.tokenId = tokenId;
        this.userId = userId;
        this.tokenHash = tokenHash;
        this.expiresAt = expiresAt;
        this.used = used;
        this.createdAt = createdAt;
    }

    public int getTokenId() {
        return tokenId;
    }

    public void setTokenId(int tokenId) {
        this.tokenId = tokenId;
    }

    public int getUserId() {
        return userId;
    }

    public void setUserId(int userId) {
        this.userId = userId;
    }

    public String getTokenHash() {
        return tokenHash;
    }

    public void setTokenHash(String tokenHash) {
        this.tokenHash = tokenHash;
    }

    public LocalDateTime getExpiresAt() {
        return expiresAt;
    }

    public void setExpiresAt(LocalDateTime expiresAt) {
        this.expiresAt = expiresAt;
    }

    public boolean isUsed() {
        return used;
    }

    public void setUsed(boolean used) {
        this.used = used;
    }

    public LocalDateTime getCreatedAt() {
        return createdAt;
    }

    public void setCreatedAt(LocalDateTime createdAt) {
        this.createdAt = createdAt;
    }
}
