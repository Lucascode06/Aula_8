-- Criação do banco de dados
CREATE DATABASE petshop_db;
USE petshop_db;

-- Tabela cliente
CREATE TABLE cliente (
    id INT AUTO_INCREMENT PRIMARY KEY,
    nome VARCHAR(100) NOT NULL,
    cpf VARCHAR(11) UNIQUE NOT NULL,
    telefone VARCHAR(15),
    email VARCHAR(100)
);

-- Tabela pet
CREATE TABLE pet (
    id INT AUTO_INCREMENT PRIMARY KEY,
    cliente_id INT NOT NULL,
    nome VARCHAR(50) NOT NULL,
    especie ENUM('cao', 'gato', 'ave', 'outros') NOT NULL,
    porte ENUM('pequeno', 'medio', 'grande') NOT NULL,
    nascimento DATE,
    FOREIGN KEY (cliente_id) REFERENCES cliente(id) ON DELETE CASCADE
);

-- Tabela servico
CREATE TABLE servico (
    id INT AUTO_INCREMENT PRIMARY KEY,
    nome VARCHAR(50) UNIQUE NOT NULL,
    preco DECIMAL(8,2) NOT NULL CHECK (preco >= 0),
    duracao_min INT NOT NULL CHECK (duracao_min > 0)
);

-- Tabela agendamento
CREATE TABLE agendamento (
    id INT AUTO_INCREMENT PRIMARY KEY,
    pet_id INT NOT NULL,
    servico_id INT NOT NULL,
    data_hora DATETIME NOT NULL,
    status ENUM('agendado', 'concluido', 'cancelado') NOT NULL DEFAULT 'agendado',
    observacoes TEXT,
    FOREIGN KEY (pet_id) REFERENCES pet(id) ON DELETE CASCADE,
    FOREIGN KEY (servico_id) REFERENCES servico(id) ON DELETE RESTRICT
);

-- Índices para otimização
CREATE INDEX idx_agendamento_data_hora ON agendamento(data_hora);
CREATE INDEX idx_pet_cliente ON pet(cliente_id);
CREATE INDEX idx_agendamento_pet ON agendamento(pet_id);
CREATE INDEX idx_agendamento_servico ON agendamento(servico_id);

-- Carga inicial de dados (SEED)

-- Clientes
INSERT INTO cliente (nome, cpf, telefone, email) VALUES 
('Maria Silva Santos', '12345678901', '11987654321', 'maria.silva@email.com'),
('João Carlos Oliveira', '23456789012', '11876543210', 'joao.carlos@email.com'),
('Ana Paula Costa', '34567890123', '11765432109', 'ana.paula@email.com');

-- Serviços
INSERT INTO servico (nome, preco, duracao_min) VALUES 
('Banho Simples', 35.00, 45),
('Banho e Tosa', 65.00, 90),
('Consulta Veterinária', 120.00, 30),
('Vacinação', 45.00, 15);

-- Pets
INSERT INTO pet (cliente_id, nome, especie, porte, nascimento) VALUES 
(1, 'Rex', 'cao', 'grande', '2020-03-15'),
(1, 'Mimi', 'gato', 'pequeno', '2021-07-22'),
(2, 'Buddy', 'cao', 'medio', '2019-11-08'),
(2, 'Piu Piu', 'ave', 'pequeno', '2022-01-10'),
(3, 'Luna', 'gato', 'medio', '2020-12-05'),
(3, 'Thor', 'cao', 'grande', '2018-05-20');

-- Agendamentos
INSERT INTO agendamento (pet_id, servico_id, data_hora, status, observacoes) VALUES 
(1, 2, '2025-09-05 10:00:00', 'agendado', 'Primeira vez - cão nervoso'),
(3, 1, '2025-09-06 14:30:00', 'agendado', 'Cliente regular'),
(5, 3, '2025-09-07 09:15:00', 'agendado', 'Consulta de rotina'),
(2, 4, '2025-09-08 11:00:00', 'agendado', 'Vacina anual'),
(6, 2, '2025-09-04 16:00:00', 'concluido', 'Serviço realizado com sucesso'),
(4, 1, '2025-09-03 08:30:00', 'cancelado', 'Cliente cancelou por motivo pessoal');