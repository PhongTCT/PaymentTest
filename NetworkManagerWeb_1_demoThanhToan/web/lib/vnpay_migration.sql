USE network_simulation_db3;
GO

-- Chạy file này một lần nếu database đã được tạo từ phiên bản cũ của dự án.
IF OBJECT_ID('dbo.PaymentTransaction', 'U') IS NULL
BEGIN
    CREATE TABLE PaymentTransaction (
        payment_id     BIGINT IDENTITY(1,1) PRIMARY KEY,
        order_id       VARCHAR(100) NOT NULL UNIQUE,
        user_id        INT NOT NULL,
        amount         BIGINT NOT NULL,
        currency       VARCHAR(3) NOT NULL DEFAULT 'VND',
        status         VARCHAR(20) NOT NULL DEFAULT 'PENDING',
        provider       VARCHAR(20) NOT NULL DEFAULT 'VNPAY',
        order_info     NVARCHAR(255),
        client_ip      VARCHAR(45),
        bank_code      VARCHAR(30),
        transaction_no VARCHAR(50),
        response_code  VARCHAR(10),
        vnp_pay_date   VARCHAR(14),
        created_at     DATETIME NOT NULL DEFAULT GETDATE(),
        paid_at        DATETIME,
        CONSTRAINT ck_payment_amount CHECK (amount > 0),
        CONSTRAINT ck_payment_status CHECK (status IN ('PENDING', 'SUCCESS', 'FAILED')),
        CONSTRAINT fk_payment_user FOREIGN KEY (user_id) REFERENCES [User](user_id)
    );
END;
GO

IF NOT EXISTS (SELECT 1 FROM sys.indexes WHERE name = 'ux_payment_transaction_no'
               AND object_id = OBJECT_ID('dbo.PaymentTransaction'))
BEGIN
    CREATE UNIQUE INDEX ux_payment_transaction_no
    ON PaymentTransaction(transaction_no)
    WHERE transaction_no IS NOT NULL AND status = 'SUCCESS';
END;
GO

IF OBJECT_ID('dbo.PremiumSubscription', 'U') IS NULL
BEGIN
    CREATE TABLE PremiumSubscription (
        user_id         INT PRIMARY KEY,
        plan_code       VARCHAR(30) NOT NULL DEFAULT 'PREMIUM_MONTHLY',
        status          VARCHAR(20) NOT NULL DEFAULT 'ACTIVE',
        started_at      DATETIME NOT NULL DEFAULT GETDATE(),
        expires_at      DATETIME NOT NULL,
        last_payment_id BIGINT,
        CONSTRAINT ck_subscription_status CHECK (status IN ('ACTIVE', 'EXPIRED', 'CANCELLED')),
        CONSTRAINT fk_subscription_user FOREIGN KEY (user_id) REFERENCES [User](user_id) ON DELETE CASCADE,
        CONSTRAINT fk_subscription_payment FOREIGN KEY (last_payment_id) REFERENCES PaymentTransaction(payment_id)
    );
END;
GO
