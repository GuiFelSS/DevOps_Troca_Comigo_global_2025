-- Tabela de Usuários
CREATE TABLE tb_usuarios (
    id VARCHAR(255) NOT NULL PRIMARY KEY,
    email VARCHAR(255) NOT NULL UNIQUE,
    full_name VARCHAR(255) NOT NULL,
    password VARCHAR(255) NOT NULL,
    user_role VARCHAR(50) DEFAULT 'USER' NOT NULL CHECK (user_role IN ('ADMIN', 'USER')),
    bio VARCHAR(255),
    avatar_url VARCHAR(255),
    time_credits DECIMAL(10, 2) DEFAULT 10.0 NOT NULL,
    total_sessions_given INT DEFAULT 0,
    total_sessions_taken INT DEFAULT 0,
    average_rating DECIMAL(3, 2) DEFAULT 0.0,
    location VARCHAR(255),
    timezone VARCHAR(255),
    linkedin_url VARCHAR(255),
    created_date DATETIME2,
    updated_date DATETIME2
);

-- Tabela de Habilidades
CREATE TABLE tb_habilidades (
    id VARCHAR(255) NOT NULL PRIMARY KEY,
    usuario_id VARCHAR(255) NOT NULL,
    name VARCHAR(255) NOT NULL,
    category VARCHAR(50) CHECK (category IN ('TECNOLOGIA', 'DESIGN', 'NEGOCIOS', 'IDIOMAS', 'MARKETING', 'DADOS', 'CRIATIVIDADE', 'SOFT_SKILLS', 'OUTROS')),
    description VARCHAR(1000),
    level VARCHAR(50) CHECK (level IN ('INICIANTE', 'INTERMEDIARIO', 'AVANCADO', 'EXPERT')),
    is_offering BIT DEFAULT 1 NOT NULL, -- BIT é o boolean do SQL Server (1=true, 0=false)
    is_seeking BIT DEFAULT 0 NOT NULL,
    hourly_rate DECIMAL(10, 2),
    created_date DATETIME2,
    CONSTRAINT fk_habilidade_usuario FOREIGN KEY (usuario_id) REFERENCES tb_usuarios(id)
);

-- Tabela de Sessões
CREATE TABLE tb_sessoes (
    id VARCHAR(255) NOT NULL PRIMARY KEY,
    mentor_id VARCHAR(255) NOT NULL,
    mentorado_id VARCHAR(255) NOT NULL,
    habilidade_id VARCHAR(255) NOT NULL,
    skill_name VARCHAR(255),
    scheduled_date DATETIME2 NOT NULL,
    duration_hours DECIMAL(10, 2) DEFAULT 1.0 NOT NULL,
    status VARCHAR(50) DEFAULT 'AGENDADA' CHECK (status IN ('AGENDADA', 'CONFIRMADA', 'EM_ANDAMENTO', 'CONCLUIDA', 'CANCELADA')),
    meeting_link VARCHAR(255),
    notes VARCHAR(2000),
    credits_value DECIMAL(10, 2),
    created_date DATETIME2,
    CONSTRAINT fk_sessao_mentor FOREIGN KEY (mentor_id) REFERENCES tb_usuarios(id),
    CONSTRAINT fk_sessao_mentorado FOREIGN KEY (mentorado_id) REFERENCES tb_usuarios(id),
    CONSTRAINT fk_sessao_habilidade FOREIGN KEY (habilidade_id) REFERENCES tb_habilidades(id)
);

-- Tabela de Transferências
CREATE TABLE tb_transferencias (
    id VARCHAR(255) NOT NULL PRIMARY KEY,
    sessao_id VARCHAR(255),
    remetente_id VARCHAR(255) NOT NULL,
    destinatario_id VARCHAR(255) NOT NULL,
    credits DECIMAL(10, 2) NOT NULL,
    type VARCHAR(50) CHECK (type IN ('PAGAMENTO_SESSAO', 'AJUSTE', 'BONUS_INICIAL', 'BONUS_REFERENCIA')),
    description VARCHAR(255),
    status VARCHAR(50) DEFAULT 'PENDENTE' CHECK (status IN ('PENDENTE', 'CONCLUIDA', 'ESTORNADA')),
    created_date DATETIME2,
    CONSTRAINT fk_transf_sessao FOREIGN KEY (sessao_id) REFERENCES tb_sessoes(id),
    CONSTRAINT fk_transf_remetente FOREIGN KEY (remetente_id) REFERENCES tb_usuarios(id),
    CONSTRAINT fk_transf_destinatario FOREIGN KEY (destinatario_id) REFERENCES tb_usuarios(id)
);

-- Tabela de Avaliações
CREATE TABLE tb_avaliacoes (
    id VARCHAR(255) NOT NULL PRIMARY KEY,
    sessao_id VARCHAR(255) NOT NULL,
    avaliador_id VARCHAR(255) NOT NULL,
    avaliado_id VARCHAR(255) NOT NULL,
    rating INT NOT NULL CHECK (rating >= 1 AND rating <= 5),
    comment VARCHAR(2000),
    created_date DATETIME2,
    CONSTRAINT fk_aval_sessao FOREIGN KEY (sessao_id) REFERENCES tb_sessoes(id),
    CONSTRAINT fk_aval_avaliador FOREIGN KEY (avaliador_id) REFERENCES tb_usuarios(id),
    CONSTRAINT fk_aval_avaliado FOREIGN KEY (avaliado_id) REFERENCES tb_usuarios(id)
);

-- Tabela de Email (do RabbitMQ)
CREATE TABLE tb_email (
    email_id UNIQUEIDENTIFIER NOT NULL PRIMARY KEY,
    owner_ref VARCHAR(255),
    email_from VARCHAR(255),
    email_to VARCHAR(255),
    subject VARCHAR(255),
    text VARCHAR(MAX),
    send_date_email DATETIME2,
    status_email VARCHAR(50) CHECK (status_email IN ('PROCESSING', 'SENT', 'ERROR'))
);