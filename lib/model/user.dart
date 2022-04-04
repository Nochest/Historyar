class Usuario {
  final int id;
  final String nombres;
  final String apellidos;
  final String celular;
  final String email;
  final String correoApoderado;
  final String fechaNacimiento;
  final int tipoUsuario;
  final String password;
  final String institucionEducativa;
  final bool celularVisible;
  final bool emailVisible;

  Usuario(this.id, this.nombres, this.apellidos, this.celular, this.email,
      this.correoApoderado, this.fechaNacimiento, this.tipoUsuario, this.password,
      this.institucionEducativa, this.celularVisible, this.emailVisible);
}