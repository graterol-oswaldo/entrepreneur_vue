<template>
  <div>
    <!--page-header> Usuarios </page-header-->

    <div class="flex space-x-2">
      <!--RouterLink class="btn btn-primary" to="/users">
        <span>Crear</span>
      </RouterLink-->
    </div>

    <div class="overflow-hidden panel mt-6">
      <div class="mb-6 flex justify-between items-center">
        <div class="flex items-center">
          <div class="flex w-full bg-white shadow rounded">
            <!-- Note: can't use v-model here, because search is a prop. -->
            <!-- Also, setSearch is debounced 300ms -->
            <input
              class=""
              type="text"
              :value="search"
              @input="setSearch"
              placeholder="Filtrar…"
            />
          </div>
        </div>
      </div>
      <div class="table-data__wrapper">
        <table class="table-data">
          <thead>
            <tr class="">
              <th class="">
                <a href="#" @click.prevent="setSort('name')">Nombre</a>
              </th>
              <th class="">
                <a href="#" @click.prevent="setSort('email')">Correo</a>
              </th>
              <th class="">
                <a href="#" @click.prevent="setSort('role')">Role</a>
              </th>
              <th class="">Acción</th>
            </tr>
          </thead>
          <tbody>
            <tr v-for="user in rows.data" :key="user.id" class="">
              <td class="">


                  {{ user.name }}
                <!--RouterLink
                  class="text-indigo-600 hover:text-indigo-800 underline"
                  to="/users"                  
                >
                  {{ user.name }}
                </RouterLink-->
              </td>
              <td class="">
                {{ user.email }}
              </td>
              <td class="">
                { user.role.name }
              </td>
              <td class="">
                <div class="flex items-center space-x-1">
                  <!--RouterLink
                    to="/users"
                    tabindex="-1"
                  >
                    <button class="btn btn-success btn-xs">Mostrar</button>
                  </RouterLink-->

                  <!--RouterLink
                    to="/users"
                    tabindex="-1"
                  >
                    <button class="btn btn-primary btn-xs">Editar</button>
                  </RouterLink-->

                  <button
                    @click="deleteRow(user.id)"
                    class="btn btn-danger btn-xs"
                  >
                    Eliminar
                  </button>
                </div>
              </td>
            </tr>
            <tr v-if="rows.length === 0">
              <td class="" colspan="4">Usuarios no encontrados.</td>
            </tr>
          </tbody>
        </table>
      </div>
      <Pagination v-if="links" :links="links" />
    </div>
  </div>
</template>

<script>
import { onMounted, ref } from "vue";
import { onBeforeRouteUpdate, useRouter, useRoute } from 'vue-router' 
import Pagination from "@/components/Pagination";
import { useSearch } from "@/hooks/useTableGrid";
import XserService from "@/services/XserService";

export default {
  name: "Xsers",
  components: {
    Pagination,
  },
  props: ["errors", "search", "sort", "direction"],  
  setup(props) {
  const router = useRouter();
  const route = useRoute();

    const rows = ref([]);
    const links = ref([]);
    const getUsers = (q="page=1") => {
      return XserService.getXsers(q)
        .then((response) => {
          rows.value = response.data;
          links.value = response.data.links;
        })
        .catch((error) => {
          console.log(error);
        });
    };
    
    onBeforeRouteUpdate(async (to, from) => {      

      if (to.query !== from.query) {        

        await getUsers(new URLSearchParams(to.query).toString());        


        //await getUsers("page="+to.query.page);        
      }
    });

    onMounted(() => {
      getUsers(new URLSearchParams(route.query).toString());    
    });
    const load = (newParams) => {
      // mix defaults and new parameters
      const params = {
        search: props.search || "",
        sort: props.sort || "",
        direction: props.direction || "",
        ...newParams,
      };
      // convert obj into url
//      const urlQuery = new URLSearchParams(params).toString();
        let routeQuery = route.query;
        const urlQuery = { ...routeQuery, ...params };
        //const xurlQuery = new URLSearchParams(urlQuery).toString();
        console.log(urlQuery);

        router.push({path:'/xsers', query: urlQuery});

//console.log(xurlQuery);
//      getUsers(xurlQuery);

//      Inertia.get(`/users?${urlQuery}`, [], {
//        preserveState: true,
//      });
    };
    const deleteRow = (rowId) => {
      if (confirm("¿Estás seguro de que quieres eliminar?")) {
        // Inertia.delete(route("users.destroy", rowId));
      }
    };

    return {
      rows,
      links,
      deleteRow,
  //    RouterLink,
      ...useSearch(props, load),
    };
  },
};
</script>
