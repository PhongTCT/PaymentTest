package Models_DAO;

import Models.RoleDTO;
import Utils.JpaUtils;
import java.util.ArrayList;
import java.util.function.Consumer;
import javax.persistence.EntityManager;
import javax.persistence.EntityTransaction;

public class RoleDAO implements IDAO<RoleDTO, Integer> {

    public RoleDAO() {
    }

    private EntityManager getEntityManager() {
        return JpaUtils.getEntityManager();
    }

    private boolean executeInTransaction(Consumer<EntityManager> action) {
        EntityManager em = getEntityManager();
        EntityTransaction tx = em.getTransaction();

        try {
            tx.begin();
            action.accept(em);
            tx.commit();
            return true;
        } catch (Exception e) {
            if (tx.isActive()) {
                tx.rollback();
            }
            e.printStackTrace();
            return false;
        } finally {
            em.close();
        }
    }

    @Override
    public boolean insert(RoleDTO t) {
        if (t == null) {
            return false;
        }
        return executeInTransaction(em -> em.persist(t));
    }

    @Override
    public boolean update(RoleDTO t) {
        if (t == null || t.getRoleId() <= 0) {
            return false;
        }
        return executeInTransaction(em -> {
            RoleDTO role = em.find(RoleDTO.class, t.getRoleId());
            if (role == null) {
                throw new IllegalArgumentException("Role not found");
            }
            role.setRoleName(t.getRoleName());
            role.setDescription(t.getDescription());
        });
    }

    @Override
    public boolean remove(RoleDTO t) {
        if (t == null || t.getRoleId() <= 0) {
            return false;
        }
        return executeInTransaction(em -> {
            RoleDTO role = em.find(RoleDTO.class, t.getRoleId());
            if (role == null) {
                throw new IllegalArgumentException("Role not found");
            }
            em.remove(role);
        });
    }

    @Override
    public ArrayList<RoleDTO> ListAll() {
        EntityManager em = getEntityManager();
        try {
            return new ArrayList<>(
                    em.createQuery("SELECT r FROM RoleDTO r ORDER BY r.roleId", RoleDTO.class)
                            .getResultList()
            );
        } finally {
            em.close();
        }
    }

    @Override
    public RoleDTO searchById(Integer id) {
        if (id == null || id <= 0) {
            return null;
        }
        EntityManager em = getEntityManager();
        try {
            return em.find(RoleDTO.class, id);
        } finally {
            em.close();
        }
    }
}
