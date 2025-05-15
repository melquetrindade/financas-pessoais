import 'package:flutter/material.dart';

class Validador {
  Validador._();

  static String? validatorNome(String? value) {
    final condition =
        RegExp(r"^[a-zA-ZáÁéÉíÍóÓúÚâÂêÊîÎôÔûÛãÃõÕçÇäÄëËïÏöÖüÜàÀèÈìÌòÒùÙñÑ]+$");
    if (value!.isEmpty) {
      return "Informe o nome corretamente!";
    } else if (condition.hasMatch(value) == false) {
      return "Nome inválido, tente novamente!";
    }
    return null;
  }

  static String? validatorEmail(String? value) {
    final condition = RegExp(r"^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$");
    if (value!.isEmpty) {
      return "Informe o e-mail corretamente!";
    } else if (condition.hasMatch(value) == false) {
      return "E-mail inválido, tente novamente!";
    }
    return null;
  }

  static String? validatorSenha(String? value) {
    final condition =
        RegExp(r"^(?=.*\d)(?=.*[a-z])(?=.*[A-Z])(?=.*[a-zA-Z]).{8,}$");
    if (value!.isEmpty) {
      return "Informe sua senha!";
    } else if (value.length < 8) {
      return "Sua senha deve ter no mínimo 8 caracteres!";
    } else if (condition.hasMatch(value) == false) {
      return "Deve ter pelo menos 8 caracteres, 1 letra maiúscula e 1 número";
    }
    return null;
  }

  static String? validatorConfirmeSenha(String? first, String? second) {
    if (first != second) {
      return "Error, as senhas são diferentes!";
    }
    return null;
  }

  static String? validatorNomeConta(String? value) {
    print("nome conta: ${value}");
    final condition = RegExp(
        r"^[a-zA-Z0-9áÁéÉíÍóÓúÚâÂêÊîÎôÔûÛãÃõÕçÇäÄëËïÏöÖüÜàÀèÈìÌòÒùÙñÑ ]+$");
    if (value!.isEmpty) {
      return "Informe o nome da conta!";
    } else if (condition.hasMatch(value) == false) {
      return "Nome inválido, apenas letras e números!";
    }
    return null;
  }

  static String? validatorSaldoConta(String? value) {
    if (value!.isEmpty) {
      return "Informe o saldo da conta!";
    }
    return null;
  }

  static String? validatorNomeCartao(String? value) {
    final condition = RegExp(
        r"^[a-zA-Z0-9áÁéÉíÍóÓúÚâÂêÊîÎôÔûÛãÃõÕçÇäÄëËïÏöÖüÜàÀèÈìÌòÒùÙñÑ ]+$");
    if (value!.isEmpty) {
      return "Informe o nome do cartão!";
    } else if (condition.hasMatch(value) == false) {
      return "Nome inválido, apenas letras e números!";
    }
    return null;
  }

  static String? validatorSaldoCartao(String? value) {
    if (value!.isEmpty) {
      return "Informe o saldo do cartão!";
    }
    return null;
  }

  static formatFechaDia(String value, TextEditingController diaFecha) {
    String novoValor = '';

    // Remove caracteres não numéricos
    for (var char in value.runes) {
      if (char >= 48 && char <= 57) { // 0-9 em ASCII
        novoValor += String.fromCharCode(char);
      }
    }

    // Se o valor estiver vazio ou começar com 0, limpa
    if (novoValor.isEmpty ||
        novoValor.startsWith('0') && novoValor.length > 1) {
      novoValor = '';
    }

    // Limita o número entre 1 e 31
    if (novoValor.isNotEmpty) {
      final numero = int.parse(novoValor);
      if (numero > 31) {
        novoValor = '31';
      } else if (numero < 1) {
        novoValor = '1';
      }
    }

    if (novoValor != value) {
      diaFecha.text = novoValor;
      diaFecha.selection = TextSelection.fromPosition(
        TextPosition(offset: novoValor.length),
      );
    }
  }

  static String? validatorDia(String? value, bool dia) {
    if(dia){
      if (value!.isEmpty) {
        return "Informe o dia do fechamento!";
      }
    } else {
      if (value!.isEmpty) {
        return "Informe o dia do vencimento!";
      }
    }
    return null;
  }
}
