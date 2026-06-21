package Utils;

import java.util.HashMap;
import java.util.Map;

import javax.persistence.EntityManager;
import javax.persistence.EntityManagerFactory;
import javax.persistence.Persistence;

public class JpaUtils {

    private static final String PERSISTENCE_UNIT_NAME = "NetworkManagerWebPU";

    private static EntityManagerFactory factory;

    static {
        try {
            Map<String, String> properties = new HashMap<>();
            properties.put("javax.persistence.jdbc.url", DbUtils.getJdbcUrl());
            properties.put("javax.persistence.jdbc.user", DbUtils.getDbUser());
            properties.put("javax.persistence.jdbc.password", DbUtils.getDbPassword());
            properties.put("javax.persistence.jdbc.driver", "org.postgresql.Driver");
            properties.put("javax.persistence.schema-generation.database.action", "none");
            factory = Persistence.createEntityManagerFactory(PERSISTENCE_UNIT_NAME, properties);
        } catch (Exception e) {
            e.printStackTrace();
            throw new ExceptionInInitializerError("Cannot create EntityManagerFactory");
        }
    }

    public static EntityManager getEntityManager() {
        return factory.createEntityManager();
    }

    public static void closeFactory() {
        if (factory != null && factory.isOpen()) {
            factory.close();
        }
    }
}
