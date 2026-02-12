import { createBrowserRouter } from "react-router";
import { LoginPage } from "./pages/LoginPage";
import { AdminLayout } from "./components/AdminLayout";
import { IngredientsTab } from "./pages/IngredientsTab";
import { EventsTab } from "./pages/EventsTab";

export const router = createBrowserRouter([
  {
    path: "/admin/login",
    Component: LoginPage,
  },
  {
    path: "/admin",
    Component: AdminLayout,
    children: [
      {
        index: true,
        Component: IngredientsTab,
      },
      {
        path: "events",
        Component: EventsTab,
      },
    ],
  },
  {
    path: "*",
    Component: () => {
      window.location.href = "/admin/login";
      return null;
    },
  },
]);
