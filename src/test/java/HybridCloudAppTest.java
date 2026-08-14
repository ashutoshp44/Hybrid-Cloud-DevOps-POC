import org.junit.jupiter.api.Test;

import static org.junit.jupiter.api.Assertions.assertEquals;

class HybridCloudAppTest {

    @Test
    void testApplicationName() {
        assertEquals(
            "Hybrid Cloud DevOps Automation PoC",
            HybridCloudApp.getApplicationName()
        );
    }
}