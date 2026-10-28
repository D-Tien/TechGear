package com.techgear.util;

import org.mindrot.jbcrypt.BCrypt;

public final class PasswordUtil {
    private PasswordUtil() { }
    public static String hashPassword(String password) {
        if (!ValidationUtil.isValidPassword(password)) throw new IllegalArgumentException("Mật khẩu phải từ 8 ký tự và tối đa 72 byte UTF-8.");
        return BCrypt.hashpw(password, BCrypt.gensalt(10));
    }
    public static boolean verifyPassword(String password, String hash) {
        if (password == null || hash == null || password.getBytes(java.nio.charset.StandardCharsets.UTF_8).length > 72) return false;
        try { return BCrypt.checkpw(password, hash); }
        catch (IllegalArgumentException | IndexOutOfBoundsException exception) { return false; }
    }
}
