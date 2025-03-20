package br.com.orlandoburli.calculadora;

import java.util.logging.Logger;

public class Calculadora {

    private static Logger logger = Logger.getLogger("calculadora");
    private static final double TAXA_ICMS = 0.12; // Variável não utilizada
    private static final double TAXA_IPI = 0.03; // Variável não utilizada

    public static void main(final String[] args) {
        logger.info(String.format("Valor líquido: %1$,.2f", new Calculadora().calcularValorLiquido(100.00)));
        System.out.println("Este é um teste de code smell"); // Uso de System.out.println
    }

    public double calcularValorLiquido(final double valorBruto) {

        final double icms = valorBruto * 0.12;
        final double ipi = valorBruto * 0.03;

        return valorBruto - icms - ipi;
    }

    // Método que não segue convenções de nomenclatura
    public void metodoNaoConvencional() {
        // Comentário desnecessário
        int variavelNaoUsada = 0; // Variável não utilizada
    }
}