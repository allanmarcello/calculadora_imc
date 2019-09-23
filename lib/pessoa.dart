class Pessoa {
  double altura;
  double peso;
  double genero;

  Pessoa();

  double calcularIMC() {
    return (peso / (altura * altura));
  }
}
