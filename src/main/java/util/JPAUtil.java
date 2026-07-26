package util;

import jakarta.persistence.EntityManager;
import jakarta.persistence.EntityManagerFactory;
import jakarta.persistence.Persistence;

/**
 * Singleton quan ly EntityManagerFactory cho Jakarta Persistence (unit: QLCCUnit)
 */
public class JPAUtil {

    private static EntityManagerFactory emf;

    static {
        try {
            emf = Persistence.createEntityManagerFactory("QLCCUnit");
        } catch (Exception e) {
            e.printStackTrace();
            System.err.println("Loi khoi tao EntityManagerFactory trong JPAUtil: " + e.getMessage());
        }
    }

    public static EntityManager getEntityManager() {
        if (emf == null || !emf.isOpen()) {
            emf = Persistence.createEntityManagerFactory("QLCCUnit");
        }
        return emf.createEntityManager();
    }

    public static void close() {
        if (emf != null && emf.isOpen()) {
            emf.close();
        }
    }
}
