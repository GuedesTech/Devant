package com.example.secretariaescolar.util;

import io.github.cdimascio.dotenv.Dotenv;
import jakarta.mail.*;
import jakarta.mail.internet.InternetAddress;
import jakarta.mail.internet.MimeMessage;

import java.util.Properties;

public class EmailUtil {

    private static final Dotenv dotenv = Dotenv.configure()
            .ignoreIfMissing()
            .load();

    private static final String REMETENTE = dotenv.get("EMAIL_REMETENTE");
    private static final String SENHA_APP = dotenv.get("EMAIL_SENHA_APP");

    public static void enviarCodigo(String destino, String codigo) throws MessagingException {
        if (REMETENTE == null || REMETENTE.isBlank()) {
            throw new IllegalStateException("EMAIL_REMETENTE não foi definido no arquivo .env");
        }

        if (SENHA_APP == null || SENHA_APP.isBlank()) {
            throw new IllegalStateException("EMAIL_SENHA_APP não foi definido no arquivo .env");
        }

        Properties props = new Properties();
        props.put("mail.smtp.auth", "true");
        props.put("mail.smtp.starttls.enable", "true");
        props.put("mail.smtp.host", "smtp.gmail.com");
        props.put("mail.smtp.port", "587");

        Session session = Session.getInstance(props, new Authenticator() {
            @Override
            protected PasswordAuthentication getPasswordAuthentication() {
                return new PasswordAuthentication(REMETENTE, SENHA_APP);
            }
        });

        Message message = new MimeMessage(session);
        message.setFrom(new InternetAddress(REMETENTE));
        message.setRecipients(Message.RecipientType.TO, InternetAddress.parse(destino));
        message.setSubject("Código de recuperação de senha - Devant");
        message.setText("Seu código de recuperação é: " + codigo);

        Transport.send(message);
    }
}